class AddCurrencyCodeToStudios < ActiveRecord::Migration[6.0]
  def change
    add_column :studios, :currency_code, :string
  end
end
