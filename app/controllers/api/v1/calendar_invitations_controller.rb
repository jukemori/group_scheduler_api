class Api::V1::CalendarInvitationsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!

  def index
    @invitations = current_user.calendar_invitations.includes(:calendar)
    render json: @invitations.as_json(include: {
      calendar: { only: [:id, :name, :description] }
    }, except: [:calendar_id])
  end
end
