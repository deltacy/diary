require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:jane) { create(:user, name: "Jane") }
  let(:appointment) { create(:appointment) }
  let!(:calendar_entry) { Diary::CalendarEntry.create(owner: jane, schedulable: appointment, start_time: 1.hour.from_now, end_time: 2.hours.from_now) }

  describe 'calendar entry' do

    it 'a calendar entry is invalid if it starts after it ends' do
      event = Diary::CalendarEntry.new(owner: jane, schedulable: appointment, start_time: 4.hour.from_now, end_time: 2.hours.from_now)

      expect(event.save).to be(false)
    end

    it 'a calendar entry contains the organiser' do
      expect(calendar_entry.ical).to include "ORGANIZER;CN=Frontida Calendar:mailto:no-reply@some-email.com"
    end

    it 'a calendar entry returns a start time' do
      expect(calendar_entry.ical).to include "DTSTART:#{calendar_entry.start_time.strftime("%Y%m%dT%H%M%S")}"
    end

    it 'a calendar entry returns an end time' do
      expect(calendar_entry.ical).to include "DTEND:#{calendar_entry.end_time.strftime("%Y%m%dT%H%M%S")}"
    end

    it 'a calendar entry has a UID' do
      expect(calendar_entry.ical).to include "UID:Appointment##{appointment.id}"
    end

    it 'a calendar entry includes the calendar name' do
      expect(calendar_entry.ical).to include "X-WR-CALNAME:Frontida Calendar"
    end

    it 'a calendar entry includes an alarm an hour before the event takes place' do
      expect(calendar_entry.ical.gsub("\r\n","\n")).to include "BEGIN:VALARM
ACTION:DISPLAY
TRIGGER:-PT1H
SUMMARY: is in 1 hour
END:VALARM"
    end

    describe 'calendar invites' do
      it "has many calendar invites" do
        expect(calendar_entry).to respond_to(:calendar_invites)
      end

      it "destroys associated calendar invites when deleted" do
        invite = create(:calendar_invite, calendar_entry: calendar_entry)

        expect { calendar_entry.destroy }.to change { Diary::CalendarInvite.count }.by(-1)
      end
    end
  end

  describe 'calendar_invite' do
    let(:calendar_invite) { build(:calendar_invite, calendar_entry: calendar_entry) }

    it "belongs to a calendar entry" do
      expect(calendar_invite).to respond_to(:calendar_entry)
    end

    it "has many calendar invitees" do
      expect(calendar_invite).to respond_to(:calendar_invitees)
    end

    it "destroys associated invitees when deleted" do
      calendar_invite = create(:calendar_invite, calendar_entry: calendar_entry)
      invitee = create(:calendar_invitee, calendar_invite: calendar_invite)

      expect { calendar_invite.destroy }.to change { Diary::CalendarInvitee.count }.by(-1)
    end

    it "it sends an email when creating an email invite for a user" do
      calendar_invite = create(:calendar_invite, calendar_entry: calendar_entry)
      invitee = create(:calendar_invitee, calendar_invite: calendar_invite, invitee: jane)


      expect { create(:calendar_invitee, calendar_invite: calendar_invite, invitee: jane) }.to change { ActionMailer::Base.deliveries.count }.by(1) 
    end
  end
end
