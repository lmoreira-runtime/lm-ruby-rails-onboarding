# frozen_string_literal: true

# Controller to manage user registration actions.
module Users
  # Controller to manage user registration actions.
  class RegistrationsController < Devise::RegistrationsController
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
end
