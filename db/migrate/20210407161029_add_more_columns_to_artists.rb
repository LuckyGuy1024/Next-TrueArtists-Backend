class AddMoreColumnsToArtists < ActiveRecord::Migration[6.0]
  def change
    remove_column :studios, :specialty
    add_column :artists, :specialty, :string
  end
end
