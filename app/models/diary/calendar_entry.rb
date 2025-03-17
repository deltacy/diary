require 'icalendar'
module Diary
  class CalendarEntry < ApplicationRecord
    has_many :calendar_invites, foreign_key: 'diary_calendar_entry_id', dependent: :destroy, inverse_of: :calendar_entry
    has_many :calendar_invitees, through: :calendar_invites

    belongs_to :owner, polymorphic: true
    belongs_to :schedulable, polymorphic: true

    validates :start_time, :owner_id, presence: true
    validates :end_time, presence: true, date: { after_or_equal_to: :start_time }

    scope :on_date, ->(date) { where(start_time: date.all_day) }
    scope :upcoming, -> { where(start_time: Time.zone.now.to_date...).order(start_time: :asc) }

    accepts_nested_attributes_for :calendar_invites

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

    def ical(calendar: Icalendar::Calendar.new, calendar_name: Diary.app_name)
      calendar.x_wr_calname = calendar_name
      calendar.event do |e|
        e.uid         = "#{schedulable.class}##{schedulable.id}"
        e.dtstart     = start_time
        e.dtend       = end_time
        e.summary     = title.presence || 'Meeting'
        e.description = description
        e.status      = 'CONFIRMED' # 'CANCELLED'
        e.location    = schedulable.address if schedulable.respond_to?(:address)
        e.organizer   = Icalendar::Values::CalAddress.new("mailto:#{Diary.calendar_sender}",
                                                          cn: "#{owner.full_name} via #{Diary.app_name}", role: 'CHAIR')
        e.attendee    = [calendar_attendee(owner, 'CHAIR')]
        invitable_attendees.map(&:invitee).each { |attendee| e.append_attendee calendar_attendee(attendee) }

        e.ip_class = 'PRIVATE'
        add_calendar_alert(e, (title.presence || 'Meeting').to_s, '-PT1H')
      end

      calendar.to_ical
    end

    private

    def invitable_attendees(attendees = [])
      calendar_invites.each do |calendar_invite|
        attendees += calendar_invite.calendar_invitees.select do |calendar_invitee|
          if Diary.email_invitee_classes.include?(calendar_invitee.invitee.class.name) && !calendar_invitee.invitee.eql?(owner)
            true
          end
        end
      end

      attendees
    end

    def add_calendar_alert(event, title, trigger)
      event.alarm do |alert|
        alert.summary = "#{title} is in 1 hour"
        alert.trigger = trigger
      end
    end

    def calendar_attendee(attendee, role = 'REQ-PARTICIPANT')
      Icalendar::Values::CalAddress.new("mailto:#{attendee.email}", cn: attendee.full_name, role:)
    end
  end
end
