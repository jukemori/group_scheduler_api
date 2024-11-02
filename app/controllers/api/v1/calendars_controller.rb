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
    @calendar = current_user.calendars.build(calendar_params)
    if @calendar.save
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

  private

  def set_calendar
    @calendar = current_user.calendars.find(params[:id])
  end

  def calendar_params
    params.require(:calendar).permit(:name, :description)
  end

end
