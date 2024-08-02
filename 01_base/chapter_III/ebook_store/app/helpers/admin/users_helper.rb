# frozen_string_literal: true

# Helper methods for admin user actions.
module Admin
  # Helper methods for admin user actions.
  module UsersHelper
    def user_category_badge(user)
      case user.category
      when 'buyer'
        'bg-primary'
      when 'seller'
        'bg-warning text-dark'
      when 'admin'
        'bg-info text-dark'
      end
    end
  end
end
