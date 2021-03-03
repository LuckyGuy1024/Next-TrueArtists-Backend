class AddStatusToTattoos < ActiveRecord::Migration[6.0]
  def change
    add_column :tattoos, :status, :string
  end
end
