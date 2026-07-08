class DirectUploadsController < ApplicationController
  include DirectUploadsHelper
  include ActionView::Helpers::UrlHelper

  before_action :authenticate_user!

  skip_authorization_check only: :create

  helper_method :render_destroy_upload_link

  def create
    @direct_upload = DirectUpload.new(
      direct_upload_params.merge(user: current_user, attachment: params[:attachment])
    )
    @direct_upload.relation.title = @direct_upload.relation.title.presence ||
                                    @direct_upload.relation.attachment_file_name

    if @direct_upload.valid?
      @direct_upload.save_attachment
      @direct_upload.relation.set_cached_attachment_from_attachment
    else
      render status: :unprocessable_content
    end
  end

  private

    def direct_upload_params
      params.require(:direct_upload)
            .permit(allowed_params)
    end

    def allowed_params
      [
        :resource, :resource_type, :resource_id, :resource_relation,
        :attachment, :cached_attachment, attachment_attributes: []
      ]
    end
end
