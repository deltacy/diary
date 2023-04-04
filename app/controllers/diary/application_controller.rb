module Diary
  class ApplicationController < ::ApplicationController
    include Diary::CalendarSubscription

    layout 'application'
  end
end
