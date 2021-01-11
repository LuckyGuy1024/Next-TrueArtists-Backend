class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.references :user
      t.string :title
      t.string :page_title
      t.string :meta_description
      t.text  :introduction
      t.text :content
      t.string :status
      t.string :slug
      t.integer :author_id
      t.timestamps
    end
  end
end
