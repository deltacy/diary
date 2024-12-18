module CalendarEntryInvitee
  extend ActiveSupport::Concern

  included do
    has_many :calendar_invites, class_name: 'Diary::CalendarInvite', as: :invitee
    has_many :calendar_entries, through: :calendar_invites, class_name: 'Diary::CalendarEntry'

    scope :is_booked_at, lambda { |date|
                           left_joins(:calendar_entries).where(':date BETWEEN start_time AND end_time', date:)
                         }
  end
end
