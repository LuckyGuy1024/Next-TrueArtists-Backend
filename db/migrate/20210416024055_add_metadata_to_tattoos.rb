class AddMetadataToTattoos < ActiveRecord::Migration[6.0]
  def change
    add_column :tattoos, :caption, :string
    add_column :tattoos, :featured, :boolean, default: false
  end
end
