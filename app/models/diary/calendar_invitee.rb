module Diary
  class CalendarInvitee < ApplicationRecord
    belongs_to :calendar_invite, class_name: 'Diary::CalendarInvite', foreign_key: 'diary_calendar_invite_id'
    belongs_to :invitee, polymorphic: true, optional: true

    validates :email, presence: true, unless: -> { invitee.present? }

    after_create :send_invitation_if_needed

    private

    def send_invitation_if_needed
      invitee_class = invitee.class.name if invitee.present?
      return unless Diary.email_invitee_classes.include?(invitee_class)

      CalendarInviteMailer.invite_email(self).deliver_later
    end
  end
end
