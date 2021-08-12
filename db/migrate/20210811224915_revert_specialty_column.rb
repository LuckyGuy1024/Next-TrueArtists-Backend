class RevertSpecialtyColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :artists, :specialty
    rename_column :artists, :new_specialty, :specialty
  end
end
