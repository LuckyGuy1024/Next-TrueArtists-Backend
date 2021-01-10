# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.timestamp :starts_at
      t.timestamp :last_run_at
      t.boolean :status
      t.references :data_source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
