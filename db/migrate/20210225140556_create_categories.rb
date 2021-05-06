class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :meta_description
      t.text :description
      t.string :status
      t.integer :parent_id
      t.string :slug
      t.timestamps
    end
    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id
  end
end
