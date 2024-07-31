class AddLastPasswordChangeAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_password_change_at, :datetime
  end
end
