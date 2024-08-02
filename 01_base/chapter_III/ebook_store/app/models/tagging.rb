# frozen_string_literal: true

# Model to represent a tagging relationship.
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :ebook
end
