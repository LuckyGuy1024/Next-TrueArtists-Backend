class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.references :receiver, polymorphic: true
      t.references :message
      t.string :mailbox_type
      t.boolean :read, default: false
      t.boolean :archived, default: false
      t.boolean :deleted, default: false
      t.timestamps
    end
  end
end
