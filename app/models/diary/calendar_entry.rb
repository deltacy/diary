module Diary
  class CalendarEntry < ApplicationRecord
    belongs_to :owner, polymorphic: true
    belongs_to :schedulable, polymorphic: true

    def owner_sgid
      owner&.to_signed_global_id
    end

    def owner_sgid=(sgid)
      self.owner = GlobalID::Locator.locate_signed(sgid)
    end

    def schedulable_sgid
      schedulable&.to_signed_global_id
    end

    def schedulable_sgid=(sgid)
      self.schedulable = GlobalID::Locator.locate_signed(sgid)
    end
  end
end
