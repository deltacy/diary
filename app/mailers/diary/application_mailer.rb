module Diary
  class ApplicationMailer < ActionMailer::Base
    default from: Diary.calendar_sender
    layout 'mailer'
  end
end
