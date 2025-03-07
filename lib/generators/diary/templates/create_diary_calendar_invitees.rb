class CreateDiaryCalendarInvitees < ActiveRecord::Migration[ActiveRecord::Migration.current_version]
  def change
    create_table :diary_calendar_invitees do |t|
      t.references :diary_calendar_invite, null: false, foreign_key: true
      t.references :invitee, polymorphic: true
      t.string :email

      t.timestamps
    end
  end
end
