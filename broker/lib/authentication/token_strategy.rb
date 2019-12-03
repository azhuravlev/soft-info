require 'warden'

module Authentication
  class TokenStrategy < Warden::Strategies::Base
    def valid?
      auth_token.present?
    end

    def authenticate!
      user = User.find_by(token: auth_token)

      if user.nil?
        fail!('Could not log in')
      else
        success!(user)
      end
    end

    private

    def auth_token
      @access_token ||= request.get_header('HTTP_X_AUTH_TOKEN')
    end
  end
end