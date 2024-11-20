module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Add debugging
      Rails.logger.debug "WS Connection Attempt - Headers: #{request.headers.to_h}"
      Rails.logger.debug "WS Connection Attempt - Params: #{request.params.to_h}"
      
      # Try headers first
      uid = request.headers['uid']
      access_token = request.headers['access-token']
      client = request.headers['client']
      
      # If headers are not present, try query parameters
      if uid.nil? || access_token.nil? || client.nil?
        uid = request.params['uid']
        access_token = request.params['access-token']
        client = request.params['client']
      end
      
      user = User.find_by(uid: uid)
      
      if user && user.valid_token?(access_token, client)
        user
      else
        reject_unauthorized_connection
      end
    rescue
      reject_unauthorized_connection
    end
  end
end
