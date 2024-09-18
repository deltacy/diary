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
end
