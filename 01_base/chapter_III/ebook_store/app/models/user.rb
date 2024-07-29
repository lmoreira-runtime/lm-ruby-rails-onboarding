class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: { buyer: 'buyer', seller: 'seller', admin: 'admin' }
  validates :category, presence: true, inclusion: { in: categories.keys }

  has_one_attached :avatar
  
  scope :enabled, -> { where(status: true) }
  scope :disabled, -> { where(status: false) }
  scope :admins, -> { where(category: 'admin') }

  before_validation :set_default_category, on: :create
  validate :admin_limit, if: :will_save_change_to_category?

  def active_for_authentication?
    super && status?
  end

  def admin?
    category == 'admin'
  end

  private

  def set_default_category
    self.category ||= 'buyer'
  end
  
  def admin_limit
    if category_changed? && category == 'admin' && !User.admins.exists?
      # Allow the first admin to be created
      return
    end

    if category_changed? && category == 'admin' && category_was != 'admin'
      errors.add(:category, "can only be set to admin by an existing admin user")
    end
  end
  
end