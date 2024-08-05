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

  def self.filter_by_tags(tag_ids)
    text_tags = Tag.where(id: tag_ids, tag_type: 'text')
    user_tags = Tag.where(id: tag_ids, tag_type: 'user')

    if text_tags.exists? && user_tags.exists?
      text_tag_ids = text_tags.pluck(:id)
      user_tag_ids = user_tags.pluck(:id)

      Ebook.joins(:taggings).where(
        'ebooks.id IN (
          SELECT ebook_id FROM taggings WHERE tag_id IN (:text_tag_ids)
        ) AND ebooks.id IN (
          SELECT ebook_id FROM taggings WHERE tag_id IN (:user_tag_ids)
        )',
        text_tag_ids:,
        user_tag_ids:
      ).distinct
    elsif text_tags.exists?
      Ebook.joins(:tags).where(tags: { id: text_tags.pluck(:id) }).distinct
    elsif user_tags.exists?
      Ebook.joins(:tags).where(tags: { id: user_tags.pluck(:id) }).distinct
    else
      Ebook.none
    end
  end

  private

  def set_default_status
    self.status ||= :draft
  end
end
