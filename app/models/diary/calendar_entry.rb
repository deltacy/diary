require 'icalendar'
module Diary
  class CalendarEntry < ApplicationRecord
    belongs_to :owner, polymorphic: true
    belongs_to :schedulable, polymorphic: true

    def owner_sgid
      owner&.to_signed_global_id
    end

    def owner_sgid=(sgid)
      self.owner = GlobalID::Locator.locate_signed(sgid)
    end

    def schedulable_sgid
      schedulable&.to_signed_global_id
    end

    def schedulable_sgid=(sgid)
      self.schedulable = GlobalID::Locator.locate_signed(sgid)
    end

    def ical(calendar: Icalendar::Calendar.new, calendar_name: Diary.app_name )
      calendar.x_wr_calname = calendar_name
      calendar.event do |e|
        e.uid         = "#{schedulable.class}##{schedulable.id.to_s}"
        e.dtstart     = start_time
        e.dtend       = end_time
        e.attendee    = ["mailto:#{owner.email}"]
        e.summary     = title
        e.description = description
        e.organizer   = "mailto:#{Diary.calendar_sender}"
        e.organizer   = Icalendar::Values::CalAddress.new("mailto:#{Diary.calendar_sender}", cn: Diary.app_name)
        e.status      = 'CONFIRMED' # 'CANCELLED'
        e.location    = schedulable.address if schedulable.respond_to?(:address)

        e.ip_class    = "PRIVATE"

        e.alarm do |a|
          a.summary = "#{title} is in 1 hour"
          a.trigger = "-PT1H" # 1 hour
        end
      end

      calendar.to_ical
    end
  end
end
