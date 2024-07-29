class StatisticsController < ApplicationController
  def index
    @ebooks = Ebook.all
  end
end
