# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :role
      t.string :password
      t.boolean :status
      t.timestamps
    end
  end
end
