# frozen_string_literal: true

# Model to represent an Ebook.
class Ebook < ApplicationRecord
  belongs_to :user
  has_many :ebook_logs, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_one_attached :pdf
  has_one_attached :cover

  enum status: { draft: 0, pending: 1, live: 2 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  validates :status, presence: true, inclusion: { in: statuses.keys.map(&:to_s) }
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_default_status, on: :create

  private

  def set_default_status
    self.status ||= :draft
  end
end
