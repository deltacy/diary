module Diary
  class CalendarEntriesController < ApplicationController
    subscribe_to_calendar

    before_action :set_calendar_entry, only: %i[show edit update destroy]

    # GET /calendar_entries
    def index
      @grouped_calendar_entries = calendar_entries.group_by { |c| c.start_time.to_datetime.to_date }
    end

    # GET /calendar_entries/1
    def show; end

    # GET /calendar_entries/new
    def new
      @calendar_entry = CalendarEntry.new
    end

    # GET /calendar_entries/1/edit
    def edit; end

    # POST /calendar_entries
    def create
      @calendar_entry = CalendarEntry.new(calendar_entry_params)

      if @calendar_entry.save
        process_invites(@calendar_entry, params[:calendar_entry][:invites])
        redirect_to @calendar_entry, notice: 'Calendar entry was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /calendar_entries/1
    def update
      if @calendar_entry.update(calendar_entry_params)
        redirect_to @calendar_entry, notice: 'Calendar entry was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /calendar_entries/1
    def destroy
      @calendar_entry.destroy
      redirect_to calendar_entries_url, notice: 'Calendar entry was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_entry
      @calendar_entry = CalendarEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calendar_entry_params
      params.require(:diary_calendar_entry).permit(
        :title, :description,
        calendar_invites_attributes: [:id, :title, :description, { invitees: [] }]
      )
    end

    def calendar_entries
      @calendar_entries ||= CalendarEntry.includes(:owner, :schedulable).order(start_time: :asc)
      @calendar_entries = @calendar_entries.where(start_time: start_time..end_time) if start_time && end_time
      @calendar_entries
    end

    def start_time
      @start_time = params[:start]
    end

    def end_time
      @end_time = params[:end]
    end

    def process_invites(calendar_entry, invites)
      invites.each do |invite_data|
        invite = calendar_entry.calendar_invites.create(title: invite_data[:title], description: invite_data[:description])
        process_invitees(invite, invite_data[:invitees])
      end
    end

    def process_invitees(invite, invitees)
      invitees.each do |invitee_data|
        if invitee_data.match?(URI::MailTo::EMAIL_REGEXP)
          invite.calendar_invitees.create(email: invitee_data)
        else
          model, id = invitee_data.split('_')
          klass = model.safe_constantize
          invite.calendar_invitees.create(invitee: klass.find(id)) if klass&.exists?(id)
        end
      end
    end
  end
end
