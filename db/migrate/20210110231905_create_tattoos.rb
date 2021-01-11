class CreateTattoos < ActiveRecord::Migration[6.0]
  def change
    create_table :tattoos do |t|
      t.text :styles
      t.string :placement
      t.string  "size"
      t.string  "color"
      t.string  "categories"
      t.string  "tattoo_style"
      t.timestamps
    end
  end
end
