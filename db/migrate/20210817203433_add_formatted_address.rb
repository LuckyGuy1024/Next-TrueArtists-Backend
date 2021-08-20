class AddFormattedAddress < ActiveRecord::Migration[6.1]
  def change
    rename_column :bookings, :city, :formatted_address
  end
end
