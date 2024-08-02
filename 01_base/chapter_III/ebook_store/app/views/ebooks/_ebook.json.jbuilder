# frozen_string_literal: true

json.extract! ebook, :id, :title, :description, :price, :status, :user_id, :created_at, :updated_at
json.url ebook_url(ebook, format: :json)
