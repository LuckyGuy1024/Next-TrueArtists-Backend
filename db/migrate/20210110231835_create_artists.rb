class CreateArtists < ActiveRecord::Migration[6.0]
  def change
    create_table :artists do |t|
      t.integer  "user_id"
      t.text     "bio"
      t.string   "slug"
      t.boolean  "licensed"
      t.boolean  "cpr_certified"
      t.integer  "years_of_experience"
      t.string  :styles
      t.string   "website"
      t.string   "facebook_url"
      t.string   "twitter_url"
      t.string   "instagram_url"
      t.string   "phone_number"
      t.decimal   "minimum_spend"
      t.decimal   "price_per_hour"
      t.string   "currency_code"
      t.integer  "status"
      t.string   "country"
      t.string   "zip_code"
      t.string   "city"
      t.integer  "account_id"
      t.boolean  "seeking_guest_spot", default: false
      t.boolean "guest_artist", default: false
      t.timestamps
    end
  end
end
