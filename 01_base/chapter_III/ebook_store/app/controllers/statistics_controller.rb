# frozen_string_literal: true

# Controller to manage statistics-related actions.
class StatisticsController < ApplicationController
  def index
    @ebooks = Ebook.all
  end
end
