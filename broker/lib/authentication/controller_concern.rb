# frozen_string_literal: true

module Authentication
  module ControllerConcern
    extend ActiveSupport::Concern

    included do
      helper_method :signed_in?, :current_user
    end

    def signed_in?
      !!current_user
    end

    def current_user
      @current_user ||= warden.authenticate(scope: :user)
    end

    def authenticate_user!
      warden.authenticate!(scope: :user)
    end

    def sign_out
      warden.logout
    end

    private

    def warden
      request.env["warden"]
    end
  end
end
