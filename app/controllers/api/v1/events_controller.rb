class Api::V1::EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :destroy]
  # authenticate_user!
      
  def index
    @events = Event.all
    render json: @events
  end
 
  def show
    render json: @event
  end
  
  def create
    # user = current_user
    # Rails.logger.debug("Current user: #{user.inspect}") # Add this line for debugging
    
    # unless user
    #   render json: { error: "User must be logged in" }, status: :unauthorized
    #   return
    # end
    Rails.logger.info("Params: #{params.inspect}")  # Log incoming parameters
    if params[:added].present?
      events = []
      params[:added].each do |event_data|
        event_params = convert_event_data(event_data)
        Rails.logger.info("Converted Event Data: #{event_params.inspect}")  # Log converted data
        event = Event.new(event_params)
        if event.save
          events << event
        else
          Rails.logger.error(event.errors.full_messages)  # Log the error details
          render json: event.errors, status: :unprocessable_entity and return
        end
      end
      render json: events, status: :created
    else
      render json: { error: "No events provided" }, status: :bad_request
    end
  end

  
  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:calendar_id, :user_id, :subject, :description, :startTime, :endTime, :startTimezone, :endTimezone, :isAllDay, :isBlock, :isReadonly, :location, :recurrenceRule, :recurrenceException, :recurrenceID, :followingID)
  end

  def convert_event_data(event_data)
    {
      # user_id: current_user.id,  
      calendar_id: 5,
      user_id: 6,  
      subject: event_data["Subject"],
      description: event_data["Description"],
      start_time: event_data["StartTime"],  
      end_time: event_data["EndTime"],      
      start_timezone: event_data["StartTimezone"],
      end_timezone: event_data["EndTimezone"],
      is_all_day: event_data["IsAllDay"],   
      is_block: event_data["IsBlock"],      
      is_readonly: event_data["IsReadonly"],
      location: event_data["Location"],
      recurrence_rule: event_data["RecurrenceRule"],
      recurrence_exception: event_data["RecurrenceException"],
      recurrence_id: event_data["RecurrenceID"], 
      following_id: event_data["FollowingID"]    
    }
  end

  def find_calendar_id_for_user
    current_user.calendars.first.id
  end

end
