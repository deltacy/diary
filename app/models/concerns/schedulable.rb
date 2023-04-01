module Schedulable
  extend ActiveSupport::Concern

  included do
    has_one :calendar_entry, class_name: 'Diary::CalendarEntry', as: :schedulable
  end
end
