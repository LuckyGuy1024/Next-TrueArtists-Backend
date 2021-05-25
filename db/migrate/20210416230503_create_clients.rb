class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.references :artist
      t.references :studio
      t.string :name
      t.string :phone_number
      t.string :email
      t.string :category
      t.date :date_of_birth
      t.boolean :email_notifications, default: false
      t.boolean :phone_notifications, default: false
      t.boolean :marketing_emails, default: false
      t.boolean :inactive, default: false
      t.string  :zip_code
      t.string :referral_source
      t.text :comments
      t.timestamps
    end
    # add_index :clients, :artist_id
    # add_index :clients, :studio_id
  end
end
