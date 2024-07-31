class RenameTypeInTagsToTagType < ActiveRecord::Migration[7.1]
  def change
    rename_column :tags, :type, :tag_type
  end
end
