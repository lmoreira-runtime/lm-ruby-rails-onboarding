class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].present?
      if @user.update(user_params)
        redirect_to admin_users_path(@user), notice: 'User was successfully updated.'
      else
        Rails.logger.debug "User update failed. Errors: #{@user.errors.full_messages}"
        render :edit
      end
    else
      if @user.update_without_password(user_params)
        redirect_to admin_users_path(@user), notice: 'User was successfully updated.'
      else
        Rails.logger.debug "User update failed. Errors: #{@user.errors.full_messages}"
        render :edit
      end
    end
  end

  def destroy
    if @user.admin? && User.admins.count == 1
      redirect_to admin_users_path, alert: 'Cannot delete the last admin user.'
    else
      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully deleted.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :category, :status)
  end

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end