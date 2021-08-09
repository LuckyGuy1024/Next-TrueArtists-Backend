class DefaultLicencedAndCprCertifiedToTrueArtist < ActiveRecord::Migration[6.1]
  def change
    change_column :artists, :licensed, :boolean, :default => false
    change_column :artists, :cpr_certified, :boolean, :default => false
  end
end
