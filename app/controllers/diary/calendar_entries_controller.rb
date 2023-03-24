module Diary
  class CalendarEntriesController < ApplicationController
    before_action :set_calendar_entry, only: %i[show edit update destroy]

    # GET /calendar_entries
    def index
      @calendar_entries = CalendarEntry.all.order(start_time: :asc)
      @grouped_calendar_entries = @calendar_entries.group_by { |c| c.start_time.to_datetime.to_date }
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
      params.require(:calendar_entry).permit(:owner_sgid, :owner_type, :title, :description, :schedulable_sgid,
                                             :start_time, :end_time, :cancellation_reason, :cancelled)
    end
  end
end
