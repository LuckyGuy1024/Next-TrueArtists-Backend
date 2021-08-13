class AddMoreColumnsInBookingRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :budget, :string
    add_column :bookings, :tattoo_color, :string
    add_column :bookings, :tattoo_size, :string
    add_column :bookings, :phone_number, :string
    add_column :bookings, :style_id, :integer
    add_column :bookings, :availability, :string

    remove_column :bookings, :height
    remove_column :bookings, :custom_size
    remove_column :bookings, :width
    remove_column :bookings, :size_units
    remove_column :bookings, :colored_tattoo

  end
end
