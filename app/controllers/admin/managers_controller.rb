class Admin::ManagersController < Admin::BaseController
  before_action :load_users, only: :index
  load_and_authorize_resource except: :index

  def index
    @users = search_or_managers.page(params[:page])
  end

  def create
    @manager.user_id = params[:user_id]
    @manager.save!

    redirect_to admin_managers_path
  end

  def destroy
    @manager.destroy!
    redirect_to admin_managers_path
  end

  private

    def load_users
      @users = User.accessible_by(current_ability)
    end

    def search_or_managers
      if params[:name_or_email]
        @users.search(params[:name_or_email]).includes(:manager)
      else
        @users.managers
      end
    end
end
