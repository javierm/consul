require 'rails_helper'

describe SignatureSheet do

  let(:signature_sheet) { build(:signature_sheet) }

  describe "validations" do

    it "should be valid" do
      expect(signature_sheet).to be_valid
    end

    it "should be valid with a valid signable" do
      signature_sheet.signable = create(:proposal)
      expect(signature_sheet).to be_valid

      signature_sheet.signable = create(:spending_proposal)
      expect(signature_sheet).to be_valid
    end

    it "should not be valid without signable" do
      signature_sheet.signable = nil
      expect(signature_sheet).to_not be_valid
    end

    it "should not be valid without a valid signable" do
      signature_sheet.signable = create(:comment)
      expect(signature_sheet).to_not be_valid
    end

    it "should not be valid without document numbers" do
      signature_sheet.document_numbers = nil
      expect(signature_sheet).to_not be_valid
    end

    it "should not be valid without an author" do
      signature_sheet.author = nil
      expect(signature_sheet).to_not be_valid
    end
  end

  describe "#name" do
    it "returns name for proposal signature sheets" do
      proposal = create(:proposal)
      signature_sheet.signable = proposal

      expect(signature_sheet.name).to eq("Citizen proposal #{proposal.id}")
    end
    it "returns name for spending proposal signature sheets" do
      spending_proposal = create(:spending_proposal)
      signature_sheet.signable = spending_proposal

      expect(signature_sheet.name).to eq("Investment project #{spending_proposal.id}")
    end
  end

  describe "#verify_signatures" do
    it "creates signatures for each document number" do
      signature_sheet = create(:signature_sheet, document_numbers: "123A, 456B")
      signature_sheet.verify_signatures

      expect(Signature.count).to eq(2)
    end

    it "marks signature sheet as processed" do
      signature_sheet = create(:signature_sheet)
      signature_sheet.verify_signatures

      expect(signature_sheet.processed).to eq(true)
    end
  end

  describe "#parsed_document_numbers" do
    it "returns an array after spliting document numbers by newlines or commas" do
      signature_sheet.document_numbers = "123A\r\n456B\n789C,123B"

      expect(signature_sheet.parsed_document_numbers).to eq(['123A', '456B', '789C', '123B'])
    end
  end

end