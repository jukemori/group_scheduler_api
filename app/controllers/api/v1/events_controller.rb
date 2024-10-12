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
        transformed_data = transform_keys_to_snake_case(event_data)
        event = Event.new(event_params(transformed_data))
        event.user_id = transformed_data['user_id'] || current_user.id 
        event.calendar_id = transformed_data['calendar_id'] || default_calendar_id 
        if event.save
          render json: event
        else
          render json: { message: "Error creating event: #{event.errors.full_messages.join(', ')}" }, status: :unprocessable_entity
          return
        end
      end
    end

    # Update existing events
    if params[:changed].present?
      params[:changed].each do |event_data|
        transformed_data = transform_keys_to_snake_case(event_data)
        event = Event.find_by(id: transformed_data[:id])
        if event&.update(event_params(transformed_data))

          event.save
          render json: event
        else
          render json: { message: "Cannot update Event with id=#{transformed_data[:id]}" }, status: :unprocessable_entity
          return
        end
      end
    end

    # Delete events
    if params[:deleted].present?
      params[:deleted].each do |event_data|
        transformed_data = transform_keys_to_snake_case(event_data)
        event_id = transformed_data[:id] || transformed_data['id']
        event = Event.find_by(id: event_id)
        if event&.destroy
          render json: event
        else
          render json: { message: "Cannot delete Event with id=#{event_data[:id]}" }, status: 500
        end
      end
    end
  end

  def event_params(params)
    params.except(:id).permit(
      :subject, :description, :start_time, :end_time, :start_timezone, :end_timezone,
      :is_all_day, :is_block, :is_readonly, :location, :recurrence_rule,
      :recurrence_exception, :recurrence_id, :following_id, :user_id, :calendar_id
    )
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

  def transform_keys_to_snake_case(hash)
    hash.deep_transform_keys do |key| 
      key = key.to_s.underscore
      key == 'owner_id' ? 'user_id' : key
    end
  end

  def default_calendar_id
    current_user.calendars.first&.id if current_user
  end
  
end
