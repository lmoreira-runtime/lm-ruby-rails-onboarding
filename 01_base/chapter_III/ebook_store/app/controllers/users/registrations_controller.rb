
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :category])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :category])
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:category])
  end

  def sign_up_params
    params = super
    params[:category] = 'buyer' if params[:category] == 'admin'
    params
  end

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:current_password)
      resource.update_without_password(params)
    else
      super
    end
  end

  private

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  
end