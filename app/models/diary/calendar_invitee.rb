module Diary
  class CalendarInvitee < ApplicationRecord
    belongs_to :calendar_invite, class_name: 'Diary::CalendarInvite', foreign_key: 'diary_calendar_invite_id',
                                 inverse_of: :calendar_invitees
    belongs_to :invitee, polymorphic: true, optional: true

    validates :email, presence: true, unless: -> { invitee.present? }

    after_create :send_invitation_if_needed

    accepts_nested_attributes_for :invitee

    private

    def send_invitation_if_needed
      invitee_class = invitee.class.name if invitee.present?
      return unless Diary.email_invitee_classes.include?(invitee_class)

      Diary.mailer_class.constantize.invite_email(self).deliver_now
    end
  end
end
