class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets do |t|
      t.integer 'attachable_id'
      t.string 'attachable_type'
      t.string 'image_content_type'
      t.string 'image_file_name'
      t.datetime 'image_updated_at'
      t.integer 'image_file_size'
      t.timestamps
      t.index ["attachable_id", "attachable_type"], name: "index_assets_on_attachable_id_and_attachable_type", length: { attachable_type: 20 }
    end
  end
end
