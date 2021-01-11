class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets do |t|
      t.integer "attachable_id"
      t.string "attachable_type"
      t.string "image_content_type"
      t.string "image_file_name"
      t.datetime "image_updated_at"
      t.integer "image_file_size"
      t.timestamps
    end
  end
end
