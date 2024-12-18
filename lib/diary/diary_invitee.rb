module Diary
  module DiaryInvitee
    extend ActiveSupport::Concern

    class_methods do
      def diary_invitee
        include CalendarEntryInvitee
      end
    end
  end
end
