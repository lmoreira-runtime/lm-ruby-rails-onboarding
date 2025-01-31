# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_731_111_508) do
  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'ebook_logs', force: :cascade do |t|
    t.integer 'ebook_id', null: false
    t.integer 'user_id', null: false
    t.integer 'action', null: false
    t.string 'ip_address'
    t.string 'browser'
    t.string 'location'
    t.integer 'seller_id'
    t.decimal 'price', precision: 10, scale: 2
    t.decimal 'fee', precision: 10, scale: 2
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ebook_id'], name: 'index_ebook_logs_on_ebook_id'
    t.index ['seller_id'], name: 'index_ebook_logs_on_seller_id'
    t.index ['user_id'], name: 'index_ebook_logs_on_user_id'
  end

  create_table 'ebooks', force: :cascade do |t|
    t.string 'title'
    t.text 'description'
    t.decimal 'price'
    t.integer 'status'
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_ebooks_on_user_id'
  end

  create_table 'taggings', force: :cascade do |t|
    t.integer 'tag_id', null: false
    t.integer 'ebook_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ebook_id'], name: 'index_taggings_on_ebook_id'
    t.index ['tag_id'], name: 'index_taggings_on_tag_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'tag_type'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'status', default: true
    t.string 'category'
    t.datetime 'last_password_change_at'
    t.string 'password_digest'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'ebook_logs', 'ebooks'
  add_foreign_key 'ebook_logs', 'users'
  add_foreign_key 'ebook_logs', 'users', column: 'seller_id'
  add_foreign_key 'ebooks', 'users'
  add_foreign_key 'taggings', 'ebooks'
  add_foreign_key 'taggings', 'tags'
end
