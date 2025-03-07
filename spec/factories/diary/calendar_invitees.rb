FactoryBot.define do
  factory :calendar_invitee, class: Diary::CalendarInvitee do
    calendar_invite { nil }
    invitee { nil }
    email { 'MyString' }
  end
end
