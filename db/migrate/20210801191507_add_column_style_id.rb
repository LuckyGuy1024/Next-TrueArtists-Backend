class AddColumnStyleId < ActiveRecord::Migration[6.1]
  def change
    remove_column :tattoos, :styles, :string
    add_column :tattoos, :style_id, :integer
    add_index :tattoos, :style_id
  end
end
