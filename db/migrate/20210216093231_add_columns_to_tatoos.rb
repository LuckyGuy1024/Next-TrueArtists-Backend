class AddColumnsToTatoos < ActiveRecord::Migration[6.0]
  def change
    add_column :tattoos, :tag_list, :string
    add_column :tattoos, :description, :string
    add_column :tattoos, :lat, :decimal, precision: 15, scale: 10
    add_column :tattoos, :lon, :decimal, precision: 15, scale: 10
  end
end
