class ChangeMessageTypeAddArchiveDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column :guest_artist_applications, :archive, :boolean, default: false 
    change_column :guest_artist_applications, :message, :text
  end
end
