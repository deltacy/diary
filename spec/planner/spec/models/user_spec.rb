require 'rails_helper'

RSpec.describe User, type: :model do
  let(:jane) { create(:user, name: "Jane") }
  let(:john) { create(:user, name: 'John') }
  let(:morven) { create(:user, name: 'Morven') }

  it 'retrieves all calendar entries for a user' do
    create_appointment(jane, 1.hour.from_now, 2.hours.from_now)
    create_appointment(jane, 4.hours.from_now, 5.hours.from_now)
    create_appointment(create(:user), 2.hours.from_now, 5.hours.from_now)

    expect(jane.calendar_entries.count).to eq(2)
  end

  it 'returns all users who are booked at a given time' do
    create_appointment(jane, 1.hour.from_now, 2.hours.from_now)

    create_appointment(john, 1.hour.from_now, 2.hours.from_now)
    create_appointment(john, 4.hours.from_now, 5.hours.from_now)

    create_appointment(morven, 1.hour.from_now, 2.hours.from_now)
    create_appointment(morven, 2.hours.from_now, 210.minutes.from_now)
    create_appointment(morven, 4.hours.from_now, 5.hours.from_now)

    expect(User.is_booked_at(90.minutes.from_now)).to eq([jane, john, morven])
    expect(User.is_booked_at(200.minutes.from_now)).to eq([morven])
    expect(User.is_booked_at(230.minutes.from_now)).to be_empty
  end

  it 'returns a fully available day for a user with no appointments' do
    travel_to Time.local(2024, 1, 1, 0, 0, 0) do

      day_start = DateTime.new(2024, 1, 1, 0, 0, 0)
      day_end = DateTime.new(2024, 1, 1, 23, 59, 59)

      availability = [
        day_start .. day_end
      ]

      expect(jane.all_availability(DateTime.now, day_start, day_end)).to eq(availability)
    end

  end

  it 'returns all available times for a user with some appointments' do
    travel_to Time.local(2024, 1, 1, 0, 0, 0) do

      day_start = DateTime.new(2024, 1, 1, 0, 0, 0)
      day_end = DateTime.new(2024, 1, 1, 23, 59, 59)

      create_appointment(jane, 13.hours.from_now, 14.hours.from_now) # 1pm to 2pm booking.
      create_appointment(jane, 15.hours.from_now, 17.hours.from_now) # 3pm to 5pm booking.

      availability = [
        day_start .. 13.hours.from_now,
        14.hours.from_now .. 15.hours.from_now,
        17.hours.from_now .. day_end
      ]

      expect(jane.all_availability(DateTime.now, day_start, day_end)).to eq(availability)
    end
  end

  it 'returns available times without empty timeslots' do
    travel_to Time.local(2024, 1, 1, 0, 0, 0) do
      day_start = DateTime.new(2024, 1, 1, 0, 0, 0)
      day_end = DateTime.new(2024, 1, 1, 23, 59, 59)

      create_appointment(jane, 13.hours.from_now, 14.hours.from_now) # 1pm to 2pm booking.
      create_appointment(jane, 14.hours.from_now, 15.hours.from_now) # 2pm to 3pm booking.

      availability = [
        day_start .. 13.hours.from_now,
        15.hours.from_now .. day_end
      ]

      expect(jane.all_availability(DateTime.now, day_start, day_end)).to eq(availability)
    end
  end

  it 'checks if a user is avaiable at a specific time' do
    travel_to Time.local(2024, 1, 1, 0, 0, 0) do
      day_start = DateTime.new(2024, 1, 1, 0, 0, 0)
      day_end = DateTime.new(2024, 1, 1, 23, 59, 59)

      create_appointment(jane, 10.hours.from_now, 11.hours.from_now)
      create_appointment(jane, 12.hours.from_now, 13.hours.from_now)
      create_appointment(jane, 14.hours.from_now, 15.hours.from_now)

      time_wanted = 8.hours.from_now .. 9.hours.from_now

      expect(jane.is_available?(time_wanted, day_start, day_end)).to eq(true)
    end
  end

  it 'checks if a user is not avaiable at a specific time' do
    travel_to Time.local(2024, 1, 1, 0, 0, 0) do
      day_start = DateTime.new(2024, 1, 1, 0, 0, 0)
      day_end = DateTime.new(2024, 1, 1, 23, 59, 59)

      create_appointment(jane, 10.hours.from_now, 11.hours.from_now)
      create_appointment(jane, 12.hours.from_now, 13.hours.from_now)
      create_appointment(jane, 14.hours.from_now, 15.hours.from_now)

      time_wanted = 570.minutes.from_now .. 630.minutes.from_now

      expect(jane.is_available?(time_wanted, day_start, day_end)).to eq(false)
    end
  end

  it 'can generate a calendar token for a user' do
    morven.generate_calendar_token

    expect(morven.calendar_token).to_not be nil
  end

  it 'does not allow two users to have the same token' do
    morven.calendar_token = "12345"
    morven.save

    jane.calendar_token = "12345"
    expect { jane.save }.to raise_error
  end

  private

  def create_appointment(owner, start_time, end_time)
    Diary::CalendarEntry.create(owner: owner, schedulable: create(:appointment), start_time: start_time, end_time: end_time)
  end
end
