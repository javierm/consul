class Admin::SiteCustomization::Documents::TableActionsComponent < ApplicationComponent
  attr_reader :document

  def initialize(document)
    @document = document
  end

  private

    def permanent_document_url(**)
      rails_storage_proxy_url(document.attachment, **)
    end
end
