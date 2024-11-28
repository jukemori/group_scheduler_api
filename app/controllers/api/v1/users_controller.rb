class Api::V1::UsersController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!, except: [:create]
  before_action :set_user, only: [:update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: current_user.to_json(include: {
      calendars: {
        include: :events
      }
    }, methods: [:photo_url])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def notifications    
    @notifications = Notification.joins(:calendar)
                               .where(calendars: { id: current_user.calendars.pluck(:id) })
                               .where.not(user_id: current_user.id)
                               .recent
                               .limit(10)                               

    render json: @notifications, include: {
      user: { only: [:id, :nickname] },
      event: { only: [:id, :subject] },
      calendar: { only: [:id, :name] },
      calendar_note: { only: [:id, :content] }
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :nickname, :color, :email, :password, :password_confirmation, :photo)
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end
end
