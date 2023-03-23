module CalendarEntryOwner
  extend ActiveSupport::Concern

  included do
    has_many :calendar_entries, class_name: 'Diary::CalendarEntry', as: :owner

    scope :is_booked_at, ->(date) { left_joins(:calendar_entries).where(':date BETWEEN start_time AND end_time', date: date) }
  end
end
