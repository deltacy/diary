class CreateDiaryCalendarEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :diary_calendar_entries do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :title
      t.text :description
      t.references :schedulable, polymorphic: true, null: false
      t.datetime :start_time
      t.datetime :end_time
      t.string :cancellation_reason
      t.boolean :cancelled

      t.timestamps
    end
  end
end
