class ChangeSpecialtyDataType < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :new_specialty, :string
  end
end
