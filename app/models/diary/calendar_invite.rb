module Diary
  class CalendarInvite < ApplicationRecord
    belongs_to :calendar_entry, class_name: 'Diary::CalendarEntry', foreign_key: 'diary_calendar_entry_id',
                                inverse_of: :calendar_invites
    has_many :calendar_invitees, foreign_key: 'diary_calendar_invite_id', dependent: :destroy, inverse_of: :calendar_invite

    accepts_nested_attributes_for :calendar_invitees
  end
end
