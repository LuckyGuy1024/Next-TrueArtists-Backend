class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.string :slug
      t.string :title
      t.text :content
      t.integer :parent_id
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
