class AddPhoneVerifiedArtistStudio < ActiveRecord::Migration[6.0]
  def change
    add_column :studios, :phone_verified, :boolean, default: false
    add_column :artists, :phone_verified, :boolean, default: false
  end
end
