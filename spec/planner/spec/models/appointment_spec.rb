require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:jane) { create(:user, name: "Jane") }
  let(:appointment) { create(:appointment) }
  let!(:calendar_entry) { Diary::CalendarEntry.create(owner: jane, schedulable: appointment, start_time: 1.hour.from_now, end_time: 2.hours.from_now) }

  let(:ical_output) do
    calendar = Icalendar::Calendar.new
    calendar_entry.add_to_ical(calendar:, calendar_name: Diary.app_name)
    calendar.publish
    calendar.to_ical
  end

  it 'a calendar entry is invalid if it starts after it ends' do
    event = Diary::CalendarEntry.new(owner: jane, schedulable: appointment, start_time: 4.hour.from_now, end_time: 2.hours.from_now)
    expect(event.save).to be(false)
  end

  it 'a calendar entry contains the organiser' do
    expect(ical_output).to include "ORGANIZER;CN=Frontida Calendar:mailto:no-reply@some-email.com"
  end

  it 'a calendar entry returns a start time' do
    expect(ical_output).to include "DTSTART:#{calendar_entry.start_time.strftime("%Y%m%dT%H%M%S")}"
  end

  it 'a calendar entry returns an end time' do
    expect(ical_output).to include "DTEND:#{calendar_entry.end_time.strftime("%Y%m%dT%H%M%S")}"
  end

  it 'a calendar entry has a UID' do
    expect(ical_output).to include "UID:Appointment##{appointment.id}"
  end

  it 'a calendar entry includes the calendar name' do
    expect(ical_output).to include "X-WR-CALNAME:Frontida Calendar"
  end

  it 'a calendar entry includes an alarm an hour before the event takes place' do
    expect(ical_output.gsub("\r\n", "\n")).to include "BEGIN:VALARM\nACTION:DISPLAY\nTRIGGER:-PT1H\nSUMMARY: is in 1 hour\nEND:VALARM"
  end
end
