# frozen_string_literal: true

class ChangeColumnPasswordToPasswordDigest < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.rename :password, :password_digest
    end
  end
end
