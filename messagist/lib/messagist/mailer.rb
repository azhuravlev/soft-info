# frozen_string_literal: true

module Messagist
  class Mailer
    def initialize(message_data)
      @message = message_data
    end

    def options
      via_params.merge(
        to:           @message['to'],
        from:         @message['from'] || 'no-reply@sofy.info',
        subject:      @message['title'] || 'SoftInfo changes'
      ).compact
    end

    private

    def via_params
      {
        via: :smtp,
        via_options: {
          address:              ENV['SMTP_ADDRESS'],
          port:                 ENV['SMTP_PORT'],
          enable_starttls_auto: false
        }
      }
    end
  end
end
