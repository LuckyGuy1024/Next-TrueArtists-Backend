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

ActiveRecord::Schema.define(version: 2021_08_01_191507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "status", default: "approved"
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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
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
    t.string "tag_list"
    t.integer "category_id"
    t.index ["category_id"], name: "index_articles_on_category_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
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
    t.integer "studio_id"
    t.text "bio"
    t.string "slug"
    t.boolean "licensed"
    t.boolean "cpr_certified"
    t.integer "years_of_experience"
    t.string "website"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "instagram_url"
    t.string "phone_number"
    t.decimal "minimum_spend"
    t.decimal "price_per_hour"
    t.string "currency_code"
    t.string "status"
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
    t.string "name"
    t.string "street_address"
    t.string "specialty"
    t.string "street_address_2"
    t.index ["guest_artist"], name: "index_artists_on_guest_artist"
    t.index ["seeking_guest_spot"], name: "index_artists_on_seeking_guest_spot"
    t.index ["studio_id"], name: "index_artists_on_studio_id"
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
    t.index ["attachable_id", "attachable_type"], name: "index_assets_on_attachable_id_and_attachable_type"
  end

  create_table "bookings", force: :cascade do |t|
    t.text "description"
    t.string "placement"
    t.boolean "consult_artist", default: false, null: false
    t.string "custom_size"
    t.string "size_units"
    t.datetime "urgency"
    t.boolean "first_tattoo", default: false, null: false
    t.boolean "colored", default: false, null: false
    t.integer "receiver_id"
    t.integer "sender_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "message_id"
    t.string "status", default: "pending"
    t.index ["message_id"], name: "index_bookings_on_message_id"
    t.index ["receiver_id"], name: "index_bookings_on_receiver_id"
    t.index ["sender_id"], name: "index_bookings_on_sender_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "meta_description"
    t.text "description"
    t.string "status"
    t.integer "parent_id"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "artist_id"
    t.bigint "studio_id"
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.string "category"
    t.date "date_of_birth"
    t.boolean "email_notifications", default: false
    t.boolean "phone_notifications", default: false
    t.boolean "marketing_emails", default: false
    t.boolean "inactive", default: false
    t.string "zip_code"
    t.string "referral_source"
    t.text "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_clients_on_artist_id"
    t.index ["studio_id"], name: "index_clients_on_studio_id"
  end

  create_table "conventions", force: :cascade do |t|
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "link_to_official_site"
    t.string "facebook_link"
    t.text "description"
    t.integer "created_by"
    t.string "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
    t.string "slug"
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

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "guest_artist_application_responses", force: :cascade do |t|
    t.bigint "guest_artist_application_id"
    t.bigint "user_id"
    t.text "message"
    t.index ["guest_artist_application_id"], name: "index_application_responses_on_application"
    t.index ["user_id"], name: "index_guest_artist_application_responses_on_user_id"
  end

  create_table "guest_artist_applications", force: :cascade do |t|
    t.bigint "studio_id"
    t.bigint "artist_id"
    t.string "phone_number"
    t.text "message"
    t.string "duration"
    t.date "expected_start_date"
    t.boolean "archive", default: false
    t.datetime "mark_as_read"
    t.index ["artist_id"], name: "index_guest_artist_applications_on_artist_id"
    t.index ["studio_id"], name: "index_guest_artist_applications_on_studio_id"
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
    t.index ["page_key"], name: "index_landing_pages_on_page_key"
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

  create_table "message_mails", force: :cascade do |t|
    t.integer "message_id", null: false
    t.integer "user_id", null: false
    t.string "thread_id"
    t.string "mail_message_id", null: false
    t.text "references"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.integer "receiver_id"
    t.integer "sender_id"
    t.boolean "sender_deleted"
    t.boolean "receiver_deleted"
    t.integer "parent_id"
    t.string "message_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "thread_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.text "content"
    t.integer "parent_id"
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "placements", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "tattoo_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_placements_on_slug"
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
    t.string "status", default: "pending", null: false
    t.bigint "artist_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone_number"
    t.index ["artist_id"], name: "index_studio_invites_on_artist_id"
    t.index ["email"], name: "index_studio_invites_on_email"
    t.index ["invite_code"], name: "index_studio_invites_on_invite_code"
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
    t.boolean "monday", default: false
    t.boolean "tuesday", default: false
    t.boolean "wednesday", default: false
    t.boolean "thursday", default: false
    t.boolean "friday", default: false
    t.boolean "saturday", default: false
    t.boolean "sunday", default: false
    t.time "monday_start"
    t.time "tuesday_start"
    t.time "wednesday_start"
    t.time "thursday_start"
    t.time "friday_start"
    t.time "saturday_start"
    t.time "sunday_start"
    t.time "monday_end"
    t.time "tuesday_end"
    t.time "wednesday_end"
    t.time "thursday_end"
    t.time "friday_end"
    t.time "saturday_end"
    t.time "sunday_end"
    t.string "currency_code"
    t.string "street_address_2"
    t.index ["accepting_guest_artist"], name: "index_studios_on_accepting_guest_artist"
    t.index ["user_id"], name: "index_studios_on_user_id"
  end

  create_table "styles", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tattoo_count", default: 0
  end

  create_table "tattoos", force: :cascade do |t|
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
    t.string "status"
    t.string "caption"
    t.boolean "featured", default: false
    t.integer "placement_id"
    t.integer "style_id"
    t.index ["placement_id"], name: "index_tattoos_on_placement_id"
    t.index ["style_id"], name: "index_tattoos_on_style_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "social_id"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email"
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["social_id"], name: "index_users_on_social_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "guest_artist_application_responses", "guest_artist_applications"
end
