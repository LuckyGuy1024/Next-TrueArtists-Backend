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
  end
end
