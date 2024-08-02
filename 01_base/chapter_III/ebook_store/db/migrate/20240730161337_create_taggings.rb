# frozen_string_literal: true

# Migration to create the taggings table.
class CreateTaggings < ActiveRecord::Migration[7.1]
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :ebook, null: false, foreign_key: true

      t.timestamps
    end
  end
end
