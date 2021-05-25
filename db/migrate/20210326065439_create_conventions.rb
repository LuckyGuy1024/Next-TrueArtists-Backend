class CreateConventions < ActiveRecord::Migration[6.0]
  def change
    create_table :conventions do |t|
      t.string   'name'
      t.datetime 'start_date'
      t.datetime 'end_date'
      t.string   'address'
      t.string   'city'
      t.string   'state'
      t.string   'country'
      t.string   'link_to_official_site'
      t.string   'facebook_link'
      t.text     'description'
      t.integer  'created_by'
      t.boolean  'verified', default: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.decimal  'lat',                  precision: 15, scale: 10
      t.decimal  'lon',                  precision: 15, scale: 10
      t.string   'slug'
    end
  end
end
