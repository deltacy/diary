module Diary
  class CalendarInvite < ApplicationRecord
    belongs_to :calendar_entry, class_name: 'Diary::CalendarEntry', foreign_key: 'diary_calendar_entry_id'

    has_many :calendar_invitees, foreign_key: 'diary_calendar_invite_id', dependent: :destroy
  end
end
