require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

require_relative '../lib/authentication/token_strategy'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Broker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.middleware.delete ::Rack::Sendfile
    config.middleware.delete ::ActionDispatch::ActionableExceptions
    config.middleware.delete ::ActionDispatch::ShowExceptions
    config.middleware.delete ::ActionDispatch::DebugExceptions
    config.middleware.delete ::ActionDispatch::Cookies
    config.middleware.delete ::ActionDispatch::Session::CookieStore
    config.middleware.delete ::ActionDispatch::Flash

    config.api_only = true
    config.middleware.insert_after ActiveRecord::Migration::CheckPending,  Warden::Manager do |manager|
      manager.default_strategies :token
      manager.failure_app = Proc.new do |env|
        ['401', {'Content-Type' => 'application/json'}, [{ error: 'Unauthorized', code: 401 }.to_json]]
      end
    end

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
