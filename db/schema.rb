# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_03_203442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "page_title"
    t.string "meta_description"
    t.text "introduction"
    t.text "content"
    t.string "status"
    t.string "slug"
    t.integer "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "artist_styles", force: :cascade do |t|
    t.bigint "artist_id"
    t.bigint "style_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_artist_styles_on_artist_id"
    t.index ["style_id"], name: "index_artist_styles_on_style_id"
  end

  create_table "artists", force: :cascade do |t|
    t.integer "user_id"
    t.text "bio"
    t.string "slug"
    t.boolean "licensed"
    t.boolean "cpr_certified"
    t.integer "years_of_experience"
    t.string "styles"
    t.string "website"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "instagram_url"
    t.string "phone_number"
    t.decimal "minimum_spend"
    t.decimal "price_per_hour"
    t.string "currency_code"
    t.integer "status"
    t.string "country"
    t.string "zip_code"
    t.string "city"
    t.integer "account_id"
    t.boolean "seeking_guest_spot", default: false
    t.boolean "guest_artist", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
    t.boolean "phone_verified", default: false
    t.string "state"
    t.index ["user_id"], name: "index_artists_on_user_id", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.integer "attachable_id"
    t.string "attachable_type"
    t.string "image_content_type"
    t.string "image_file_name"
    t.datetime "image_updated_at"
    t.integer "image_file_size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.string "favoritable_type", null: false
    t.bigint "favoritable_id", null: false
    t.string "favoritor_type", null: false
    t.bigint "favoritor_id", null: false
    t.string "scope", default: "favorite", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blocked"], name: "index_favorites_on_blocked"
    t.index ["favoritable_id", "favoritable_type"], name: "fk_favoritables"
    t.index ["favoritable_type", "favoritable_id"], name: "index_favorites_on_favoritable_type_and_favoritable_id"
    t.index ["favoritor_id", "favoritor_type"], name: "fk_favorites"
    t.index ["favoritor_type", "favoritor_id"], name: "index_favorites_on_favoritor_type_and_favoritor_id"
    t.index ["scope"], name: "index_favorites_on_scope"
  end

  create_table "landing_pages", force: :cascade do |t|
    t.string "page_key"
    t.string "page_url"
    t.string "page_title"
    t.string "meta_description"
    t.string "title"
    t.text "content"
    t.string "status"
    t.integer "last_updated_by"
    t.string "moved_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "country"
    t.string "state"
    t.string "city"
    t.integer "studio_count"
    t.integer "artist_count"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
  end

  create_table "messages", force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.integer "receiver_id"
    t.string "sender_id"
    t.boolean "sender_deleted"
    t.boolean "receiver_deleted"
    t.integer "parent_id"
    t.string "message_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "studio_artists", force: :cascade do |t|
    t.bigint "studio_id"
    t.bigint "artist_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_studio_artists_on_artist_id"
    t.index ["studio_id"], name: "index_studio_artists_on_studio_id"
  end

  create_table "studio_invites", force: :cascade do |t|
    t.bigint "studio_id"
    t.string "invite_code"
    t.string "email"
    t.boolean "accepted", default: false
    t.bigint "artist_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone_number"
    t.index ["artist_id"], name: "index_studio_invites_on_artist_id"
    t.index ["studio_id"], name: "index_studio_invites_on_studio_id"
  end

  create_table "studios", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "bio"
    t.string "city"
    t.string "state"
    t.string "street_address"
    t.string "zip_code"
    t.string "country"
    t.string "phone_number"
    t.text "specialty"
    t.text "accepted_payment_methods"
    t.boolean "appointment_only", default: false
    t.text "languages"
    t.text "services"
    t.string "email"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "instagram_url"
    t.string "website_url"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
    t.string "status"
    t.string "slug"
    t.boolean "accepting_guest_artist", default: false
    t.boolean "piercings", default: false
    t.boolean "cosmetic_tattoos", default: true
    t.boolean "vegan_ink", default: false
    t.boolean "wifi", default: true
    t.boolean "privacy_dividers", default: false
    t.boolean "wheelchair_access", default: false
    t.boolean "parking", default: false
    t.boolean "lgbt_friendly", default: true
    t.decimal "price_per_hour"
    t.decimal "minimum_spend"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "phone_verified", default: false
    t.index ["user_id"], name: "index_studios_on_user_id", unique: true
  end

  create_table "styles", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tattoos", force: :cascade do |t|
    t.text "styles"
    t.string "placement"
    t.string "size"
    t.string "color"
    t.string "categories"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "artist_id"
    t.integer "studio_id"
    t.string "tag_list"
    t.string "description"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
