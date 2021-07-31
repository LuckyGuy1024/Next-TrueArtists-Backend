class CreatePlacements < ActiveRecord::Migration[6.1]
  def change
    create_table :placements do |t|
      t.string :name
      t.string :slug
      t.integer :tattoo_count, default: 0
      t.timestamps
    end

    add_column :styles, :tattoo_count, :integer, default: 0
    add_column :tattoos, :placement_id, :integer
    add_index :tattoos, :placement_id
    add_index :placements, :slug

    Placement::OPTIONS.each do |option|
      placement = Placement.new(name: option)
      placement.save

      tattoo_image = Tattoo.search(option).results&.last&.image
      if tattoo_image&.attached?
        placement.avatar.attach(io: open(tattoo_image), filename: "#{option} Tattoos")
      end
    end
  end
end
