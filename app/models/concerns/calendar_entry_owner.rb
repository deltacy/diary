module CalendarEntryOwner
  extend ActiveSupport::Concern

  included do
    has_many :calendar_entries, class_name: 'Diary::CalendarEntry', as: :owner

    scope :is_booked_at, lambda { |date|
                           left_joins(:calendar_entries).where(':date BETWEEN start_time AND end_time', date:)
    }
  end

  def generate_calendar_token
    return unless respond_to?(:calendar_token)

    self.calendar_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.where(calendar_token: random_token).exists?
    end

    self.calendar_token_created_at = Time.zone.now
    save!
  end

  def all_availability(date, day_start=DateTime.today.beginning_of_day, day_end=DateTime.today.end_of_day, calendar_entry=nil)
    bookings = calendar_entries.on_date(date) - [calendar_entry]

    x = day_start
    slots = []
    bookings.each do |dt|
      if (x != dt.start_time)
        range = x .. dt.start_time
        slots << range
      end
      x = dt.end_time
    end
    slots << (x .. day_end)
  end

  def is_available?(date_time_range, day_start=DateTime.today.beginning_of_day, day_end=DateTime.today.end_of_day)
    times = all_availability(day_start, day_start, day_end)

    times.each do |t|
      return true if t.cover? date_time_range
    end
    false
  end
end
