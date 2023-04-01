require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:jane) { create(:user, name: "Jane") }
  let(:appointment) { create(:appointment) }

  it 'a schedulable item belongs to a calendar entry' do
    calendar_entry = Diary::CalendarEntry.create(owner: jane, schedulable: appointment, start_time: 1.hour.from_now, end_time: 2.hours.from_now)

    expect(calendar_entry.schedulable).to eq(appointment)
    expect(appointment.calendar_entry).to eq(calendar_entry)
  end
end
