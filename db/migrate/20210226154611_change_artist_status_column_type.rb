class ChangeArtistStatusColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :artists, :status, :string
  end
end
