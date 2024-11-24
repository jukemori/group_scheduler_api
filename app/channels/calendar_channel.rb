class CalendarChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user.id}_notifications"
  end

  def unsubscribed
    stop_all_streams
  end
end