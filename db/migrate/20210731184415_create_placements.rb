class CreatePlacements < ActiveRecord::Migration[6.1]
  def change
    create_table :placements do |t|
      t.string :name
      t.string :slug
      t.integer :tattoo_count, default: 0
      t.timestamps
    end

    add_column :styles, :tattoo_count, :integer, default: 0
    add_column :tattoos, :placement_id, :integer
    add_index :tattoos, :placement_id
    add_index :placements, :slug
  end
end
