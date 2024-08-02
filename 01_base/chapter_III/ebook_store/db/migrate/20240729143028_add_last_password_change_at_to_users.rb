# frozen_string_literal: true

# Migration to add the last_password_change_at column to the users table.
class AddLastPasswordChangeAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_password_change_at, :datetime
  end
end
