class CreateStudioInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :studio_invites do |t|
      t.references :studio
      t.string :invite_code
      t.string :email
      t.boolean :accepted, default: false
      t.references :artist
      t.timestamps
    end
    add_index :studio_invites, :invite_code
    add_index :studio_invites, :email
  end
end
