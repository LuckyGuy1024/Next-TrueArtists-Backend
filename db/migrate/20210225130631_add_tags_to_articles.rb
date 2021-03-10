class AddTagsToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :tag_list, :string
  end
end
