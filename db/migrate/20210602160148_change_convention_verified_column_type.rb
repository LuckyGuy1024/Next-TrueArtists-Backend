class ChangeConventionVerifiedColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :conventions, :verified, :string, default: nil
  end
end
