class Api::V1::EventsController < ApplicationController
  # Handles both fetching and CRUD operations (create, update, delete)
  def crud_actions
    # Fetch data if no params are added
    if params[:added].nil? && params[:changed].nil? && params[:deleted].nil?
      fetch_events
    else
      handle_crud_operations
    end
  end

  private

  def fetch_events
    if params[:StartDate].present? && params[:EndDate].present?
      start_date = params[:StartDate]
      end_date = params[:EndDate]
      events = Event.where("start_time >= ? AND end_time <= ?", start_date, end_date)
    else
      events = Event.all 
    end

    transformed_events = events.map { |event| transform_event_keys(event) }
    Rails.logger.info("Transformed Events: #{transformed_events}")
    render json: transformed_events
  rescue => e
    render json: { message: e.message || "Some error occurred while retrieving Events." }, status: 500
  end

  # Method to handle create, update, delete operations
  def handle_crud_operations
    # Create new events
    if params[:added].present?
      params[:added].each do |event_data|
        event = Event.new(event_data.permit(:user_id, :calendar_id, :event_data_attributes)) # Adjust strong params
        if event.save
          render json: event
        else
          render json: { message: "Some error occurred while inserting the event." }, status: 500
        end
      end
    end

    # Update existing events
    if params[:changed].present?
      params[:changed].each do |event_data|
        event = Event.find_by(id: event_data[:id])
        if event&.update(event_data.permit(:user_id, :calendar_id, :event_data_attributes))
          render json: event
        else
          render json: { message: "Cannot update Event with id=#{event_data[:id]}" }, status: 500
        end
      end
    end

    # Delete events
    if params[:deleted].present?
      params[:deleted].each do |event_data|
        event = Event.find_by(id: event_data[:id])
        if event&.destroy
          render json: event
        else
          render json: { message: "Cannot delete Event with id=#{event_data[:id]}" }, status: 500
        end
      end
    end
  end

  def transform_event_keys(event)
    event_hash = event.attributes

    transformed_event = {}

    event_hash.each do |key, value|
      new_key = key.split('_').map(&:capitalize).join
      transformed_event[new_key] = value
    end

    transformed_event
  end
end
