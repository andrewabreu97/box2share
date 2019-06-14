class Admin::UsersController < Admin::ApplicationController
  before_action :require_existing_user, only: [:destroy]

  def index
    @users = User.where(admin: false)
  end

  def destroy
  end

  private
    def require_existing_user
      @user = User.find(params[:id])
    rescue
      redirect_to admin_users_path, alert: "Este usuario no existe o ya ha sido eliminado."
    end

end
