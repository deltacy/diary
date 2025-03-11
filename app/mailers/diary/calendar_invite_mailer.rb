module Diary
  class CalendarInviteMailer < ApplicationMailer
    def invite_email(calendar_invitee)
      @event = calendar_invitee.calendar_invite.calendar_entry
      @calendar_invite = calendar_invitee.calendar_invite
      @recipient = calendar_invitee.invitee || calendar_invitee.email

      attachments['event.ics'] = { mime_type: 'text/calendar',
                                   content: @calendar_invite.calendar_entry.ical }
      mail(
        to: @recipient.respond_to?(:email) ? @recipient.email : @recipient,
        subject: "[#{Diary.app_name}] You have been added to #{@calendar_invite.calendar_entry.title || 'an event'}"
      )
    end
  end
end
