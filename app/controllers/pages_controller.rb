class PagesController < ApplicationController
  skip_before_action :vertify_authenticity_token, railse: false
  before_action :authenticate_user!, only: [:restricted]
  def home
  end

  def restricted
    devise_api_token = current_devise_api_token
    if devise_api_token
      render json: { message: "You are logged in as #{devise_api_token.resource_owner.email}" }, status: :ok
    else
      render json: { message: "You are not logged in" }, status: :unauthorized
  end
end
