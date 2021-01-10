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

ActiveRecord::Schema.define(version: 2020_07_14_132703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_mappings", force: :cascade do |t|
    t.string "mapping_type"
    t.string "key"
    t.string "value"
    t.bigint "supplier_id", null: false
    t.bigint "data_source_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["data_source_id"], name: "index_data_mappings_on_data_source_id"
    t.index ["supplier_id"], name: "index_data_mappings_on_supplier_id"
  end

  create_table "data_sources", force: :cascade do |t|
    t.string "name"
    t.string "source_type"
    t.string "api_key"
    t.string "api_token"
    t.string "URL"
    t.json "configuration"
    t.string "store_name"
    t.bigint "supplier_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["supplier_id"], name: "index_data_sources_on_supplier_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "last_run_at"
    t.boolean "status"
    t.bigint "data_source_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["data_source_id"], name: "index_jobs_on_data_source_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "legal_business_name"
    t.string "contact_email"
    t.string "point_of_contact"
    t.string "customer_support_email"
    t.string "street_address"
    t.string "street_address_2"
    t.string "city"
    t.string "postal_code"
    t.string "country"
    t.string "phone_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_suppliers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "data_mappings", "data_sources"
  add_foreign_key "data_mappings", "suppliers"
  add_foreign_key "data_sources", "suppliers"
  add_foreign_key "jobs", "data_sources"
  add_foreign_key "suppliers", "users"
end
