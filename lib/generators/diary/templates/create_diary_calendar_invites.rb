class CreateDiaryCalendarInvites < ActiveRecord::Migration[ActiveRecord::Migration.current_version]
  def change
    create_table :diary_calendar_invites do |t|
      t.references :diary_calendar_entry, null: false, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
