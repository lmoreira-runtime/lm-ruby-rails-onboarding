module Admin::UsersHelper
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
