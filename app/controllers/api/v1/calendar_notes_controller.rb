class Api::V1::CalendarNotesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :set_note, only: [:update, :destroy]

  def index
    @notes = @calendar.calendar_notes.includes(:user)
    render json: @notes.map { |note|
      {
        id: note.id,
        content: note.content,
        created_at: note.created_at,
        updated_at: note.updated_at,
        user: {
          id: note.user.id,
          nickname: note.user.nickname,
          email: note.user.email
        }
      }
    }
  end

  def create
    @note = @calendar.calendar_notes.build(note_params)
    @note.user = current_user

    if @note.save
      create_notification('created', @note)
      render json: @note, status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      create_notification('updated', @note)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def destroy
    create_notification('deleted', @note)
    @note.destroy
    head :no_content
  end

  private

  def set_calendar
    @calendar = current_user.calendars.find(params[:calendar_id])
  end

  def set_note
    @note = @calendar.calendar_notes.find(params[:id])
  end

  def note_params
    params.require(:calendar_note).permit(:content)
  end

  def create_notification(action, note)
    users_to_notify = note.calendar.users.where.not(id: current_user.id)

    notification = Notification.create!(
      user: current_user,
      calendar: note.calendar,
      calendar_note: note,
      action: action,
      notification_type: 'note',
      message: "#{current_user.nickname} #{action} note: #{note.content.truncate(30)}"
    )

    users_to_notify.each do |user|
      channel = "user_#{user.id}_notifications"
      payload = {
        type: 'notification',
        notification: {
          id: notification.id,
          message: notification.message,
          created_at: notification.created_at,
          calendar_id: note.calendar_id,
          notification_type: notification.notification_type,
          user: {
            id: current_user.id,
            nickname: current_user.nickname
          },
          note: {
            id: note.id,
            content: note.content.truncate(30)
          }
        },
        action_id: "#{action}_note_#{note.id}_#{Time.current.to_i}"
      }
      
      ActionCable.server.broadcast(channel, payload)
    end
  end
end

