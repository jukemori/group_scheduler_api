class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  protected

  def configure_permitted_parameters
    return unless resource_class.present?
    
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :nickname])
  end
end
