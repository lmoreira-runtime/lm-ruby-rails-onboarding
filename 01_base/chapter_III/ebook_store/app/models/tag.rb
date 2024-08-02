# frozen_string_literal: true

# Model to represent a Tag.
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :ebooks, through: :taggings

  validates :name, presence: true, uniqueness: true
  validates :tag_type, presence: true, inclusion: { in: %w[text user] }
end
