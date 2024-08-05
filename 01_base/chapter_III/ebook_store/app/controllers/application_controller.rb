# frozen_string_literal: true

# Base controller for the application.
class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def require_user
    return if user_signed_in?

    flash[:alert] = 'You must be logged in to perform that action'
    redirect_to login_path
  end

  def authorize_admin
    redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user&.admin?
  end

  protected

  def authorize_seller_or_admin
    if current_user.seller?
      redirect_to ebooks_path, alert: 'You are not authorized to perform this action.' unless @ebook.user == current_user
    elsif !current_user.admin?
      redirect_to ebooks_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def authorize_buyer_or_seller
    return if current_user.buyer? || current_user.seller?

    redirect_to ebooks_path, alert: 'You are not authorized to perform this action.'
  end
end
