require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:jane) { create(:user, name: "Jane") }
  let(:appointment) { create(:appointment) }
  let!(:calendar_entry) { Diary::CalendarEntry.create(owner: jane, schedulable: appointment, start_time: 1.hour.from_now, end_time: 2.hours.from_now) }

  it 'a calendar entry contains the organiser' do
    expect(calendar_entry.ical).to include "ORGANIZER;CN=Frontida Calendar:mailto:no-reply@some-email.com"
  end

  it 'a calendar entry returns a start time' do
    expect(calendar_entry.ical).to include "DTSTART:#{calendar_entry.start_time.strftime("%Y%m%dT%H%M%S")}"
  end

  it 'a calendar entry returns an end time' do
    expect(calendar_entry.ical).to include "DTEND:#{calendar_entry.end_time.strftime("%Y%m%dT%H%M%S")}"
  end

  it 'a calendar entry has a UID' do
    expect(calendar_entry.ical).to include "UID:Appointment##{appointment.id}"
  end

  it 'a calendar entry includes the calendar name' do
    expect(calendar_entry.ical).to include "X-WR-CALNAME:Frontida Calendar"
  end

  it 'a calendar entry includes an alarm an hour before the event takes place' do
    expect(calendar_entry.ical.gsub("\r\n","\n")).to include "BEGIN:VALARM
ACTION:DISPLAY
TRIGGER:-PT1H
SUMMARY: is in 1 hour
END:VALARM"
  end
end
