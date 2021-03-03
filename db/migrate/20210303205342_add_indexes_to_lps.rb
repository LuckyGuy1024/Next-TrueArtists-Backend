class AddIndexesToLps < ActiveRecord::Migration[6.0]
  def change
    add_index :landing_pages, :page_key
  end
end
