class AddSlugToTattoos < ActiveRecord::Migration[6.1]
  def change
    add_column :tattoos, :slug, :string
    add_index :tattoos, :slug
  end
end
