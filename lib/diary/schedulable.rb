module Diary
  module Schedulable
    extend ActiveSupport::Concern

    class_methods do
      def schedulable
        include ::Schedulable
      end
    end
  end
end
