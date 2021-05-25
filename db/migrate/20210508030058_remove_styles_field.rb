class RemoveStylesField < ActiveRecord::Migration[6.0]
  def change
    remove_column :artists, :styles
  end
end
