class RemoveTattooStyleFromTattoos < ActiveRecord::Migration[6.0]
  def change
    remove_column :tattoos, :tattoo_style
  end
end
