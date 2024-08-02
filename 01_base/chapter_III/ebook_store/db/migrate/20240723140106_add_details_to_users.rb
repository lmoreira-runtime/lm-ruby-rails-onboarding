# frozen_string_literal: true

# Migration to add additional details to the users table.
class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :boolean, default: true
    add_column :users, :category, :string
  end
end
