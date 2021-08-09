class ChangeServicesToArrayField < ActiveRecord::Migration[6.1]
  def change
    remove_column :studios, :services, :text
    add_column :studios, :services, :string, array: true
  end
end
