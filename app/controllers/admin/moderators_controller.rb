class Admin::ModeratorsController < Admin::BaseController
  before_action :load_users, only: :index
  load_and_authorize_resource except: :index

  def index
    @users = search_or_moderators.page(params[:page])
  end

  def create
    @moderator.user_id = params[:user_id]
    @moderator.save!

    redirect_to admin_moderators_path
  end

  def destroy
    @moderator.destroy!
    redirect_to admin_moderators_path
  end

  private

    def load_users
      @users = User.accessible_by(current_ability)
    end

    def search_or_moderators
      if params[:name_or_email]
        @users.search(params[:name_or_email]).includes(:moderator)
      else
        @users.moderators
      end
    end
end
