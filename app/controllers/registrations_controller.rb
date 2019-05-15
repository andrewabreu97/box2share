class RegistrationsController < Devise::RegistrationsController

private

  def sign_up_params
    params.require(:user).permit(:name, :last_name, :email, :password,
      :password_confirmation, :avatar, :avatar_cache, :remove_avatar)
  end

  def account_update_params
    params.require(:user).permit(:name, :last_name, :email, :password,
      :password_confirmation, :current_password, :avatar, :avatar_cache,
      :remove_avatar)
  end

protected
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

end
