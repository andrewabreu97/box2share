class Admin::UsersController < Admin::ApplicationController
  before_action :require_existing_user, only: [:destroy]

  def index
    @users = User.where(admin: false)
  end

  def destroy
    unless @user.current_subscription.free?
      workflow = CancelsStripeSubscription.new(
          subscription_id: @user.current_subscription.id,
          user: @user)
      workflow.run
      if workflow.success
        if @user.destroy
          redirect_to admin_users_path, notice: "El usuario ha sido eliminado correctamente."
        else
          redirect_to admin_users_path, alert: "Ha ocurrido un error al intentar eliminar el usuario."
        end
      else
        redirect_to admin_users_path, alert: "Ha ocurrido un error al intentar cancelar la suscripción del usuario a eliminar."
      end
    else
      if @user.destroy
        redirect_to admin_users_path, notice: "El usuario ha sido eliminado correctamente."
      else
        redirect_to admin_users_path, alert: "Ha ocurrido un error al intentar eliminar el usuario."
      end
    end
  end

  private
    def require_existing_user
      @user = User.find(params[:id])
    rescue
      redirect_to admin_users_path, alert: "Este usuario no existe o ya ha sido eliminado."
    end

end
