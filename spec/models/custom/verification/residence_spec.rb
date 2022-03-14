require "rails_helper"

describe Verification::Residence do
  let(:residence) { build(:verification_residence, document_number: "12345678Z") }

  describe "verification" do
    describe "postal code", :consul do
      it "is valid with postal codes starting with 280" do
        residence.postal_code = "28012"
        residence.valid?
        expect(residence.errors[:postal_code]).to be_empty

        residence.postal_code = "28023"
        residence.valid?
        expect(residence.errors[:postal_code]).to be_empty
      end

      it "is not valid with postal codes not starting with 280" do
        residence.postal_code = "12345"
        residence.valid?
        expect(residence.errors[:postal_code].size).to eq(1)

        residence.postal_code = "13280"
        residence.valid?
        expect(residence.errors[:postal_code]).to eq ["In order to be verified, you must be registered."]
      end
    end
  end

  describe "save" do
    let(:residence) { build(:verification_residence, document_number: "7010101890123") }

    it "stores document number and gender" do
      user = create(:user)
      residence.user = user
      residence.save!

      user.reload
      expect(user.document_number).to eq("7010101890123")
      expect(user.document_type).to eq("1")
      expect(user.gender).to eq("male")
    end
  end
end
