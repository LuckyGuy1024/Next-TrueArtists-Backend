class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.text :description
      t.string :placement
      t.boolean :consult_artist, null: false, default: false
      t.string :custom_size
      t.string :size_units
      t.datetime :urgency
      t.boolean :first_tattoo, null: false, default: false
      t.boolean :colored, null: false, default: false
      t.integer 'receiver_id'
      t.integer 'sender_id'
      t.timestamps
      t.references :message
    end
    add_index :bookings, :receiver_id
    add_index :bookings, :sender_id
  end
end
