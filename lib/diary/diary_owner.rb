module Diary
  module DiaryOwner
    extend ActiveSupport::Concern

    class_methods do
      def diary_owner
        include CalendarEntryOwner
      end
    end
  end
end
