class TweakBookingsMigrations < ActiveRecord::Migration[6.1]
  def change
    change_column :bookings, :custom_size, :boolean
    rename_column :bookings, :placement, :tattoo_placement
    rename_column :bookings, :colored, :colored_tattoo
    add_column :bookings, :height, :integer
    add_column :bookings, :width, :integer
    add_column :bookings, :city, :string
  end
end
