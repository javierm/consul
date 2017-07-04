require 'rails_helper'

describe Verification::Residence do

  let!(:geozone) { create(:geozone, census_code: "01") }
  let(:residence) { build(:verification_residence, document_number: "12345678Z") }
  let(:attrs) { {user: create(:user), official: create(:user, :level_three) } }

  describe "validations" do

    it "should be valid" do
      expect(residence).to be_valid
    end

    describe "dates" do
      it "should be valid if user has allowed age" do
        new_attrs = { date_of_birth: Date.new(1970, 1, 1) }
        new_attrs[:user] = create(:user, :residence_requested)
        residence = build(:verification_residence, attrs.merge(new_attrs))
        residence.valid?
        expect(residence.errors[:date_of_birth].size).to eq(0)
      end

      it "should not be valid if user has not allowed age" do
        new_attrs = { date_of_birth: 5.years.ago }
        new_attrs[:user] = create(:user, :residence_requested)
        residence = build(:verification_residence, attrs.merge(new_attrs))
        expect(residence).to_not be_valid
        expect(residence.errors[:date_of_birth]).to include("You must be at least 16 years old")
      end

      it "should not be valid without a date of birth" do
        new_attrs = { date_of_birth: nil }
        new_attrs[:user] = create(:user, :residence_requested)
        residence = build(:verification_residence, attrs.merge(new_attrs))
        expect(residence).to_not be_valid
        expect(residence.errors[:date_of_birth]).to include("can't be blank")
      end
    end

    describe "document number" do
      it "should permit duplication of document_number for same user when requesting verification" do
        user = build(:user, document_number: residence.document_number)
        residence.user = user
        residence.valid?
        expect(residence.errors[:document_number]).to eq([])
      end

      it "should permit duplication of document_number for same user when verifying" do
        user = build(:user, :residence_requested, document_number: residence.document_number)
        residence.user = user
        residence.official = create(:user, :level_three)
        residence.valid?
        expect(residence.errors[:document_number]).to eq([])
      end

      it "should validate uniquness of document_number" do
        user = create(:user, document_number: residence.document_number)
        residence.valid?
        expect(residence.errors[:document_number]).to include("has already been taken")
      end
    end

    it "should validate census terms" do
      residence.terms_of_service = nil
      expect(residence).to_not be_valid
    end

  end

  describe "new" do
    it "should upcase document number" do
      residence = Verification::Residence.new({document_number: "x1234567z"})
      expect(residence.document_number).to eq("X1234567Z")
    end

    it "should remove all characters except numbers and letters" do
      residence = Verification::Residence.new({document_number: " 12.345.678 - B"})
      expect(residence.document_number).to eq("12345678B")
    end
  end

  describe "save" do

    it "should store document number, document type, date of birth, geozone_id and residence_requested_at when requesting verification" do
      residence = build(:verification_residence, attrs.merge({document_number: '12345678Z', geozone_id: geozone.id}))
      user = residence.user
      residence.save

      user.reload
      expect(user.document_number).to eq('12345678Z')
      expect(user.document_type).to eq("1")
      expect(user.date_of_birth.year).to eq(1970)
      expect(user.date_of_birth.month).to eq(1)
      expect(user.date_of_birth.day).to eq(1)
      expect(user.geozone).to eq(geozone)
      expect(user.residence_requested_at).to_not be(nil)
    end

    it "should store residence_verified_at when verifying" do
      user = create(:user, :residence_requested, date_of_birth: '1970-01-01'.to_date)
      residence = build(:verification_residence, attrs.merge({user: user, document_number: '12345678Z', geozone_id: geozone.id}))
      residence.mode = :manual # NOTE we skip residence web service verification until we have access
      residence.save

      user.reload
      #expect(user.gender).to eq('male')
      #expect(user.geozone).to eq(geozone)
      expect(user.residence_verified_at).to_not be(nil)
    end

  end

  describe "tries" do
    it "should increase tries after a call to the Census" do
      residence = build(:verification_residence, :invalid, attrs.merge(user: create(:user, :residence_requested), document_number: "12345678Z"))
      residence.valid?
      expect(residence.user.lock.tries).to eq(1)
    end

    it "should not increase tries after a validation error" do
      residence.postal_code = ""
      residence.valid?
      expect(residence.user.lock).to be nil
    end
  end

  describe "Failed census call" do
    it "stores failed census API calls" do
      residence = build(:verification_residence, :invalid, attrs.merge(user: create(:user, :residence_requested), document_number: "12345678Z"))
      residence.save

      expect(FailedCensusCall.count).to eq(1)
      expect(FailedCensusCall.first).to have_attributes({
        user_id:         residence.user.id,
        document_number: "12345678Z",
        document_type:   "1",
        date_of_birth:   Date.new(1970, 1, 1),
        postal_code:     "35001"
      })
    end
  end

end
