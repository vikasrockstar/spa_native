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

ActiveRecord::Schema[7.0].define(version: 2023_10_04_094948) do
  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bank_accounts", charset: "utf8mb4", force: :cascade do |t|
    t.string "bank_name"
    t.string "account_holder_name"
    t.string "account_number"
    t.string "account_type"
    t.integer "user_id"
    t.text "address"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ifsc_code"
    t.datetime "deleted_at"
    t.string "frequency", default: "weekly"
    t.index ["deleted_at"], name: "index_bank_accounts_on_deleted_at"
  end

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.json "data"
    t.string "source"
    t.string "event_type"
    t.text "processing_errors"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qr_codes", charset: "utf8mb4", force: :cascade do |t|
    t.string "url"
    t.float "amount"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["user_id"], name: "index_qr_codes_on_user_id"
  end

  create_table "reviews", charset: "utf8mb4", force: :cascade do |t|
    t.integer "rating"
    t.text "review"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "transactions", charset: "utf8mb4", force: :cascade do |t|
    t.float "amount"
    t.integer "bank_account_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", default: "plumbing"
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_number"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "otp_secret_key"
    t.integer "otp_counter", default: 0
    t.boolean "is_mobile_verified", default: false
    t.string "profile_picture_file_name"
    t.string "profile_picture_content_type"
    t.bigint "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.date "dob"
    t.string "payment_link"
    t.string "business_id_card"
    t.text "address"
    t.text "about_me"
    t.boolean "bank_added", default: false
    t.string "country_chars"
    t.string "language_preference", default: "English"
    t.boolean "suspended", default: false
  end

  create_table "version_managers", charset: "utf8mb4", force: :cascade do |t|
    t.string "device_type"
    t.string "app_version"
    t.string "message"
    t.boolean "is_force_update"
    t.boolean "is_soft_update"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallet_histories", charset: "utf8mb4", force: :cascade do |t|
    t.integer "updated_by_user"
    t.float "previous_balance"
    t.float "updated_balance"
    t.string "checkout_session_object_id"
    t.bigint "wallet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wallet_id"], name: "index_wallet_histories_on_wallet_id"
  end

  create_table "wallets", charset: "utf8mb4", force: :cascade do |t|
    t.float "balance", default: 0.0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "withdrawal_requests", charset: "utf8mb4", force: :cascade do |t|
    t.float "amount", default: 0.0
    t.integer "status", default: 0
    t.datetime "completion_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_withdrawal_requests_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "qr_codes", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "transactions", "users"
  add_foreign_key "wallet_histories", "wallets"
  add_foreign_key "withdrawal_requests", "users"
end
