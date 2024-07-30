class PasswordExpiredController < ApplicationController
  before_action :authenticate_user!
  
  def edit
  end

  def update
    if current_user.update(password_params)
      redirect_to root_path, notice: 'Password updated successfully'
    else
      render :edit
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
