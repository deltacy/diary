module Diary
  module CalendarSubscription
    extend ActiveSupport::Concern

    class_methods do
      def subscribe_to_calendar
        include ::CalendarSubscribe
      end
    end
  end
end
