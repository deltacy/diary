class CreateDiaryCalendarInvites < ActiveRecord::Migration[7.2]
  def change
    create_table :diary_calendar_invites do |t|
      t.references :diary_calendar_entry, null: false, foreign_key: true
      t.references :invitee, polymorphic: true, null: false

      t.timestamps
    end
  end
end
