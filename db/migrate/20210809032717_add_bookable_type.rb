class AddBookableType < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :bookable_type, :string
    add_column :bookings, :bookable_id, :integer
    add_index :bookings, %i[bookable_type bookable_id], name: :booking_id
  end
end
