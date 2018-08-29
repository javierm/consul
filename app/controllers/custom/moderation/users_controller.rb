class Moderation::UsersController < Moderation::BaseController

  before_action :load_users, only: :index

  load_and_authorize_resource

  def index
  end

  def hide_in_moderation_screen
    block_user

    redirect_to request.query_parameters.merge(action: :index), notice: I18n.t('moderation.users.notice_hide')
  end

  def hide
    block_user

    redirect_to debates_path
  end

  def index_for_geozone
    @users = User.by_username_email_or_document_number(params[:search]) if params[:search]
    @users = @users.page(params[:page])
    @geozone = current_user.geozone
    unless @geozone
      flash[:error] = t('moderation.users.geozone_validation.no_geozone_error', login: current_user.email)
      redirect_to moderation_root_path and return
    end
    unless Verification::Residence.geozone_is_protected?(@geozone)
      flash[:error] = t('moderation.users.geozone_validation.geozone_not_protected', geozone: @geozone.name)
      redirect_to moderation_root_path and return
    end
    @users = @users.where(geozone_id: @geozone).where('document_number IS NOT NULL').order('created_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end

  def verify_geozone_residence
    @user = User.find(params[:id])
    residence = params[:residence] == 'true'
    if residence
      @user.residence_verified_at = Time.current
      @user.residence_requested_at = nil
      @sms = Verification::Sms.new(phone: @user.unconfirmed_phone, user: @user)
      @sms.save
    else
      @user.residence_verified_at = nil
      @user.residence_requested_at = nil
    end
    @user.save
  end

  private

    def load_users
      @users = User.with_hidden.search(params[:name_or_email]).page(params[:page]).for_render
    end

    def block_user
      @user.block
      Activity.log(current_user, :block, @user)
    end

end
