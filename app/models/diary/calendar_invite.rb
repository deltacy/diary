module Diary
  class CalendarInvite < ApplicationRecord
    belongs_to :diary_calendar_entry, class_name: 'CalendarEntry'
    belongs_to :invitee, polymorphic: true
  end
end
