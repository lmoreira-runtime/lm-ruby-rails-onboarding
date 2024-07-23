class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum category: { buyer: 'buyer', seller: 'seller', admin: 'admin' }
  validates :category, presence: true, inclusion: { in: categories.keys }

  scope :enabled, -> { where(status: true) }
  scope :disabled, -> { where(status: false) }

  def active_for_authentication?
    super && status?
  end
end