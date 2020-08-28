class Verification::Management::ManagedUser
  include ActiveModel::Model

  def self.find(document_type, document_number)
    User.where("document_number is not null").
         find_by(document_type: document_type, document_number: document_number)
  end
end
