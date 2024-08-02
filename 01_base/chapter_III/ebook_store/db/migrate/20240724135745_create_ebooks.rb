# frozen_string_literal: true

# Migration to create the ebooks table.
class CreateEbooks < ActiveRecord::Migration[7.1]
  # Migration to create the ebooks table.
  def change
    create_table :ebooks do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
