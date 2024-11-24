class Api::V1::CalendarsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :set_calendar, only: [:show, :update, :destroy, :invite, :notifications]

  def index
    @calendars = current_user.calendars
    render json: @calendars
  end

  def show
    render json: @calendar
  end

  def create
    @calendar = Calendar.new(calendar_params)
    if @calendar.save
      @calendar.users << current_user
      render json: @calendar, status: :created
    else
      render json: @calendar.errors, status: :unprocessable_entity
    end
  end

  def update
    if @calendar.update(calendar_params)
      render json: @calendar
    else
      render json: @calendar.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @calendar.destroy
    head :no_content
  end

  def invite
    @user = User.find_by(email: calendar_params[:email])
    
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if @calendar.users.include?(@user)
      render json: { error: 'User is already a member of this calendar' }, status: :unprocessable_entity
      return
    end

    invitation = @calendar.calendar_invitations.new(
      user: @user,
      status: :pending
    )
    
    if invitation.save
      render json: { message: 'Invitation sent successfully' }, status: :ok
    else
      render json: { error: invitation.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def accept_invitation
    invitation = current_user.calendar_invitations.find_by(calendar_id: params[:id])
    
    if invitation.nil?
      render json: { error: 'Invitation not found' }, status: :not_found
      return
    end

    if invitation.accepted?
      render json: { error: 'Invitation already accepted' }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      invitation.update!(status: :accepted)
      invitation.calendar.users << current_user unless invitation.calendar.users.include?(current_user)
    end

    render json: { message: 'Calendar invitation accepted' }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def reject_invitation
    invitation = current_user.calendar_invitations.find_by(calendar_id: params[:id])
    
    if invitation.nil?
      render json: { error: 'Invitation not found' }, status: :not_found
      return
    end

    if invitation.rejected?
      render json: { error: 'Invitation already rejected' }, status: :unprocessable_entity
      return
    end

    invitation.rejected!
    render json: { message: 'Calendar invitation rejected' }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def users
    @calendar = Calendar.find(params[:id])
    users_data = @calendar.users.map do |user|
      {
        OwnerText: user.nickname,
        Id: user.id,
        OwnerColor: user.color 
      }
    end
    
    render json: users_data
  end

  def notifications
    @notifications = @calendar.notifications.recent.limit(5)
    render json: @notifications, include: {
      user: { only: [:id, :nickname] },
      event: { only: [:id, :subject] }
    }
  end

  private

  def set_calendar
    @calendar = current_user.calendars.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Calendar not found' }, status: :not_found
  end

  def calendar_params
    params.require(:calendar).permit(:name, :description, :email)
  end

  def generate_random_color
    "##{SecureRandom.hex(3)}"
  end

end
