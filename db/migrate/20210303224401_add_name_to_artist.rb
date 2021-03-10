class AddNameToArtist < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :name, :string
  end
end
