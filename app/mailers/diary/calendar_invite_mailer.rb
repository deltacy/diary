module Diary
  class CalendarInviteMailer < ApplicationMailer
    def invite_email(calendar_invitee)
      @calendar_invite = calendar_invitee.calendar_invite
      @recipient = calendar_invitee.invitee || calendar_invitee.email

      mail(
        to: @recipient.respond_to?(:email) ? @recipient.email : @recipient,
        subject: "You have been added to event #{@calendar_invite.calendar_entry.title}"
      )
    end
  end
end
