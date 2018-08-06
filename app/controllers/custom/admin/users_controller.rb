class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @users = User.by_username_email_or_document_number(params[:search]) if params[:search]
    @users = @users.page(params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index_for_geozone
    @users = User.by_username_email_or_document_number(params[:search]) if params[:search]
    @users = @users.page(params[:page])
    @geozone = Geozone.find(params[:geozone])
    @users = @users.where(geozone_id: @geozone)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def verify_geozone_residence
    @user = User.find(params[:id])
    @user.geozone_residence = params[:residence]
    @user.save
  end
end
