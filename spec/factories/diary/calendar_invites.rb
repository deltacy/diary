FactoryBot.define do
  factory :calendar_invite, class: Diary::CalendarInvite do
    calendar_entry { nil }
    title { 'MyString' }
    description { 'MyText' }
  end
end
