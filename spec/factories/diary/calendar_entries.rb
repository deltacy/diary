FactoryBot.define do
  factory :calendar_entry, class: Diary::CalendarEntry do
    start_time { Time.zone.now }
    start_time { 2.hours.from_now }
  end
end
