class AddSlugToTables < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slug, :string
    add_index :articles, :slug, unique: true
    add_index :users, :slug, unique: true
  end
end
