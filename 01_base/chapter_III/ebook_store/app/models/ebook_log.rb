# frozen_string_literal: true

# Model to represent a log entry for an Ebook.
class EbookLog < ApplicationRecord
  belongs_to :ebook
  belongs_to :user
  belongs_to :seller, class_name: 'User', optional: true

  enum action: { draft_viewed: 0, ebook_seen: 1, ebook_purchased: 2 }

  validates :action, presence: true, inclusion: { in: actions.keys }
  validates :ip_address, presence: true
  validates :browser, presence: true
  validates :location, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :fee, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
