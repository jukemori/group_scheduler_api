class Api::V1::CalendarsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  before_action :set_calendar, only: [:show, :update, :destroy]

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
    @user = User.find_by(email: params[:email])
    
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if @calendar.users.include?(@user)
      render json: { error: 'User is already a member of this calendar' }, status: :unprocessable_entity
      return
    end

    @calendar.users << @user
    render json: { message: 'User successfully invited to calendar' }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_calendar
    @calendar = current_user.calendars.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:name, :description)
  end

end
