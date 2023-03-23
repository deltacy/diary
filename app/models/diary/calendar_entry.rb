module Diary
  class CalendarEntry < ApplicationRecord
    belongs_to :owner, polymorphic: true
    belongs_to :schedulable, polymorphic: true
  end
end
