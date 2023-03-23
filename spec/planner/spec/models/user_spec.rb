require 'rails_helper'

RSpec.describe User, type: :model do
  let(:jane) { create(:user, name: "Jane") }
  let(:john) { create(:user, name: 'John') }
  let(:morven) { create(:user, name: 'Morven') }

  it 'retrieves all calendar entries for a user' do
    Diary::CalendarEntry.create(owner: jane, schedulable: create(:appointment), start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    Diary::CalendarEntry.create(owner: jane, schedulable: create(:appointment), start_time: 4.hours.from_now, end_time: 5.hours.from_now)
    Diary::CalendarEntry.create(owner: create(:user), schedulable: create(:appointment), start_time: 2.hours.from_now, end_time: 5.hours.from_now)

    expect(jane.calendar_entries.count).to eq(2)
  end

  it 'returns all users who are booked at a given time' do
    Diary::CalendarEntry.create(owner: jane, schedulable: create(:appointment), start_time: 1.hour.from_now, end_time: 2.hours.from_now)

    Diary::CalendarEntry.create(owner: john, schedulable: create(:appointment), start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    Diary::CalendarEntry.create(owner: john, schedulable: create(:appointment), start_time: 4.hour.from_now, end_time: 5.hours.from_now)

    Diary::CalendarEntry.create(owner: morven, schedulable: create(:appointment), start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    Diary::CalendarEntry.create(owner: morven, schedulable: create(:appointment), start_time: 2.hour.from_now, end_time: 210.minutes.from_now)
    Diary::CalendarEntry.create(owner: morven, schedulable: create(:appointment), start_time: 4.hour.from_now, end_time: 5.hours.from_now)

    expect(User.is_booked_at(90.minutes.from_now)).to eq([jane, john, morven])
    expect(User.is_booked_at(200.minutes.from_now)).to eq([morven])
    expect(User.is_booked_at(230.minutes.from_now)).to be_empty
  end
end
