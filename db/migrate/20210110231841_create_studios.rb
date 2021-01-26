class CreateStudios < ActiveRecord::Migration[6.0]
  def change
    create_table :studios do |t|
      t.integer  'user_id'
      t.string   'name'
      t.text     'bio'
      t.string   'city'
      t.string   'state'
      t.string   'street_address'
      t.string   'zip_code'
      t.string   'country'
      t.string   'phone_number'
      t.text     'specialty'
      t.text     'accepted_payment_methods'
      t.boolean  'appointment_only', default: false
      t.text     'languages'
      t.text     'services'
      t.string   'email'
      t.string   'facebook_url'
      t.string   'twitter_url'
      t.string   'instagram_url'
      t.string   'website_url'
      t.decimal  'lat',                  precision: 15, scale: 10
      t.decimal  'lon',                  precision: 15, scale: 10
      t.string   'status'
      t.string   'slug'
      t.boolean  'accepting_guest_artist', default: false
      t.boolean :piercings, default: false
      t.boolean :cosmetic_tattoos, default: true
      t.boolean :vegan_ink, default: false
      t.boolean :wifi, default: true
      t.boolean :privacy_dividers, default: false
      t.boolean :wheelchair_access, default: false
      t.boolean :parking, default: false
      t.boolean :lgbt_friendly, default: true
      t.decimal :price_per_hour
      t.decimal :minimum_spend
      t.timestamps
    end
  end
end
