class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def require_user
    unless user_signed_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end

  
  # before_action :configure_permitted_parameters, if: :devise_controller?

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:category])
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:category])
  # end

  def authorize_admin
    redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin?
  end
end