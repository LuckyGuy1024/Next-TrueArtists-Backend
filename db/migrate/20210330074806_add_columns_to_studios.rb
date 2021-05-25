class AddColumnsToStudios < ActiveRecord::Migration[6.0]
  def change
    change_table :studios do |t|
      t.boolean  'monday',                                         default: false
      t.boolean  'tuesday',                                        default: false
      t.boolean  'wednesday',                                      default: false
      t.boolean  'thursday',                                       default: false
      t.boolean  'friday',                                         default: false
      t.boolean  'saturday',                                       default: false
      t.boolean  'sunday',                                         default: false
      t.time     'monday_start'
      t.time     'tuesday_start'
      t.time     'wednesday_start'
      t.time     'thursday_start'
      t.time     'friday_start'
      t.time     'saturday_start'
      t.time     'sunday_start'
      t.time     'monday_end'
      t.time     'tuesday_end'
      t.time     'wednesday_end'
      t.time     'thursday_end'
      t.time     'friday_end'
      t.time     'saturday_end'
      t.time     'sunday_end'
    end
  end
end
