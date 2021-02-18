class AddStateToArtists < ActiveRecord::Migration[6.0]
  def change
    add_column :artists, :state, :string
  end
end
