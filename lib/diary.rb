require 'diary/version'
require 'diary/engine'
require 'diary/diary_owner'
require 'diary/schedulable'
require 'diary/calendar_subscription'
require 'diary/configuration'

module Diary
  class << self
    attr_accessor :configuration
  end

  mattr_accessor :calendar_sender
  @calendar_name = nil

  mattr_accessor :app_name
  @app_name = nil

  mattr_accessor :email_invitee_classes
  @email_invitee_classes = []

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.setup
    yield self
  end
end
