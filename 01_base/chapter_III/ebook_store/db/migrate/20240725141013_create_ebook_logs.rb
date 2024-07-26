class CreateEbookLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :ebook_logs do |t|
      t.references :ebook, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :action, null: false
      t.string :ip_address
      t.string :browser
      t.string :location
      t.references :seller, null: true, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.decimal :fee, precision: 10, scale: 2

      t.timestamps
    end
  end
end
