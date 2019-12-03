require_relative '../../lib/authentication/controller_concern'

::Warden::Strategies.add(:token, Authentication::TokenStrategy)