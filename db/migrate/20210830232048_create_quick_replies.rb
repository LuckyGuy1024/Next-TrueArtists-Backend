class CreateQuickReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :quick_replies do |t|
      t.references :owner, polymorphic: true
      t.string :name
      t.text :content
      t.string :category
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
