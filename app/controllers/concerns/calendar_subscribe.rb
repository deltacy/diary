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

  def icalendar_with(calendar: Icalendar::Calendar.new, entries:)
    entries.each { |entry| entry.ical(calendar: calendar, calendar_name: Diary.app_name) }
    calendar
  end
end
