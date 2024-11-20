class CalendarChannel < ApplicationCable::Channel
  def subscribed
    calendar_id = params[:calendar_id]
    calendar = Calendar.find(calendar_id)
    
    if calendar.users.include?(current_user)
      stream_from "calendar_#{calendar_id}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end