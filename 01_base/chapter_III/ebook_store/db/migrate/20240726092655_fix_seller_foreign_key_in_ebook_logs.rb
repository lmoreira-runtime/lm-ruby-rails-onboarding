# frozen_string_literal: true

# Migration to fix the seller foreign key in the ebook_logs table.
class FixSellerForeignKeyInEbookLogs < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :ebook_logs, :sellers
    add_foreign_key :ebook_logs, :users, column: :seller_id
  end
end
