module Diary
  class Configuration
    attr_accessor :email_invitee_classes

    def initialize
      @email_invitee_classes = []
      @mailer_class = 'CalendarInviteMailer'
    end
  end
end
