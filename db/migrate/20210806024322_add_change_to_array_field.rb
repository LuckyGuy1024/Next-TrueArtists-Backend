class AddChangeToArrayField < ActiveRecord::Migration[6.1]
  def change
    remove_column :artists, :specialty
    add_column :artists, :specialty, :string, array: true
  end
end
