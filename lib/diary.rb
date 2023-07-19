require 'diary/version'
require 'diary/engine'
require 'diary/diary_owner'
require 'diary/schedulable'
require 'diary/calendar_subscription'

module Diary
  mattr_accessor :calendar_sender
  @calendar_name = nil

  mattr_accessor :app_name
  @app_name = nil

  def self.setup
    yield self
  end
end
