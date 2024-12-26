class Api::V1::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def resource_class
    User
  end

  def omniauth_success
    Rails.logger.info "Received params: #{params.inspect}"
    
    @resource = get_resource_from_auth_hash
    
    # Create client id and token
    @token = @resource.create_token
    @resource.save!

    # Set token headers
    set_token_headers
    
    # Return both user data and tokens in the response
    auth_response = {
      status: 'success',
      data: resource_data,
      tokens: {
        'access-token': @token.token,
        'client': @token.client,
        'uid': @resource.uid,
        'expiry': @token.expiry.to_s
      }
    }

    Rails.logger.info "Sending response: #{auth_response.inspect}"
    render json: auth_response
  end

  protected

  def get_resource_from_auth_hash
    Rails.logger.info "Processing OAuth callback with params: #{params.inspect}"
    
    @resource = resource_class.where(
      provider: auth_params[:provider],
      uid: auth_params[:uid]
    ).or(
      resource_class.where(
        email: auth_params.dig(:info, :email)
      )
    ).first_or_initialize

    if @resource.new_record?
      @resource.assign_attributes(
        email: auth_params.dig(:info, :email),
        name: auth_params.dig(:info, :name),
        nickname: auth_params.dig(:info, :nickname),
        image: auth_params.dig(:info, :image),
        provider: auth_params[:provider],
        uid: auth_params[:uid]
      )
      @resource.skip_confirmation! if @resource.respond_to?(:skip_confirmation!)
    end

    @resource.save!
    @resource
  end

  def create_token_info
    @token = @resource.create_token
    @resource.save!
  end

  def set_token_headers
    response.headers.merge!(
      'access-token' => @token.token,
      'client' => @token.client,
      'uid' => @resource.uid,
      'expiry' => @token.expiry.to_s,
      'token-type' => 'Bearer'
    )
    
    response.headers['Access-Control-Expose-Headers'] = 
      'access-token, client, uid, expiry, token-type'
  end

  def resource_data
    {
      id: @resource.id,
      uid: @resource.uid,
      email: @resource.email,
      name: @resource.name,
      nickname: @resource.nickname,
      image: @resource.image,
      provider: @resource.provider,
      tokens: {
        'access-token': @token.token,
        'client': @token.client,
        'uid': @resource.uid,
        'expiry': @token.expiry
      }
    }
  end

  private

  def auth_params
    params.require(:omniauth).permit(
      :provider,
      :uid,
      info: [:email, :name, :nickname, :image],
      credentials: [:token, :refresh_token, :id_token]
    )
  end

  def omniauth_window_type
    params[:omniauth_window_type] || 'newWindow'
  end
end
