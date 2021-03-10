class CreateStyles < ActiveRecord::Migration[6.0]
  def change
    create_table :styles do |t|
      t.string :slug
      t.string :name 
      t.timestamps
    end
  end
end
