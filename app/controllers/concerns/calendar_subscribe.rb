module CalendarSubscribe
  extend ActiveSupport::Concern

  def subscribe
    calendar = icalendar_with(entries: calendar_entries)

    respond_to do |format|
      format.html
      format.ics do
        calendar.publish
        render plain: calendar.to_ical
      end
    end
  end

  private

  def icalendar_with(entries:, calendar: Icalendar::Calendar.new)
    entries.each { |entry| entry.add_to_ical(calendar:, calendar_name: Diary.app_name) }
    calendar
  end
end
