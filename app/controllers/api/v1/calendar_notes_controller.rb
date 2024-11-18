
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
      render json: @note, status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def destroy
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
end

