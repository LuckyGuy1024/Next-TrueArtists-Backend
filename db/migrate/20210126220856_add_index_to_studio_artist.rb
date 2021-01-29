class AddIndexToStudioArtist < ActiveRecord::Migration[6.0]
  def change
    add_index :studios, :user_id, unique: true
    add_index :artists, :user_id, unique: true
  end
end
