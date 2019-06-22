class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :destroy, :statistics]

  def index
    @users = User.where(admin: false)
  end

  def show
  end

  def destroy
    workflow = DeleteUser.new(subscription_id: @user.current_subscription.id, user: @user)
    workflow.run
    if workflow.success
      redirect_to admin_users_path, notice: "El usuario ha sido eliminado correctamente."
    else
      redirect_to admin_users_path, alert: "Ha ocurrido un error al intentar eliminar el usuario."
    end
  end

  def statistics
  end

  private

    def set_user
      @user = User.find(params[:id] || params[:user_id])
    rescue
      redirect_to admin_users_path, alert: "Este usuario no existe o ya ha sido eliminado."
    end

end
