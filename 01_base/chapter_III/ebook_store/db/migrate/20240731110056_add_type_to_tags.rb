# frozen_string_literal: true

# Migration to add the type column to the tags table.
class AddTypeToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :type, :string
  end
end
