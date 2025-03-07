module Diary
  class Configuration
    attr_accessor :email_invitee_classes

    def initialize
      @email_invitee_classes = []
    end
  end
end
