# frozen_string_literal: true

# Migration to rename the type column to tag_type in the tags table.
class RenameTypeInTagsToTagType < ActiveRecord::Migration[7.1]
  def change
    rename_column :tags, :type, :tag_type
  end
end
