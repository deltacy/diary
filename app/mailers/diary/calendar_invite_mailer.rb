module Diary
  class CalendarInviteMailer < ApplicationMailer
    def invite_email(calendar_invitee)
      @calendar_invite = calendar_invitee.calendar_invite
      @recipient = calendar_invitee.invitee || calendar_invitee.email

      mail(
        to: @recipient.respond_to?(:email) ? @recipient.email : @recipient,
        subject: "You're invited to #{@calendar_invite.title}"
      )
    end
  end
end
