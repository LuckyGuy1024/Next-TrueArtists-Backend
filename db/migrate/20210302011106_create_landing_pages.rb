class CreateLandingPages < ActiveRecord::Migration[6.0]
  def change
    create_table :landing_pages do |t|
      t.string :page_key
      t.string :page_url
      t.string :page_title
      t.string :meta_description
      t.string :title
      t.text   :content
      t.string :status
      t.integer :last_updated_by
      t.string :moved_to
      t.timestamps
    end
  end
end
