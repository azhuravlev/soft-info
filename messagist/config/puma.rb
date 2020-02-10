# frozen_string_literal: true

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
#
port        ENV.fetch('APP_PORT') { 3033 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RACK_ENV') { 'development' }
