# frozen_string_literal: true

# Migration to create the tags table.
class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
