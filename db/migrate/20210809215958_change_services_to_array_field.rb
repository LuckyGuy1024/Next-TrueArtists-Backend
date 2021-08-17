class ChangeServicesToArrayField < ActiveRecord::Migration[6.1]
  def change
    change_column :studios, :services, :string
    change_column :studios, :languages, :string
  end
end
