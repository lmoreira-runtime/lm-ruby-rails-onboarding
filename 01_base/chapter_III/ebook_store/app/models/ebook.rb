class Ebook < ApplicationRecord
  belongs_to :user
  has_many :purchases
  has_one :ebook_statistic

  has_one_attached :pdf

  enum status: { draft: 0, pending: 1, live: 2 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  validates :status, presence: true, inclusion: { in: statuses.keys.map(&:to_s) }
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_default_status, on: :create
  #mount_uploader :preview_pdf, PdfUploader

  #after_create :create_ebook_statistic

  private

  def set_default_status
    self.status ||= :draft
  end
  
  # def create_ebook_statistic
  #   EbookStatistic.create(ebook: self)
  # end
end