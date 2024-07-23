
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:category])
  end

  def sign_up_params
    params = super
    params[:category] = 'buyer' if params[:category] == 'admin'
    params
  end
end