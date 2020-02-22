# frozen_string_literal: true

require File.join(__dir__, '..', 'messagist.rb')

require 'erb'
require 'sneakers'
require 'sneakers/worker'
require_relative 'mailer'
require_relative 'slack_client'

module Messagist
  class Worker
    include Sneakers::Worker
    from_queue "tool_messages"

    def work(msg)
      message_data = JSON.parse(msg)
      send_message(message_data)
      ack!
    end

    def send_message(message_data)
      send_mail(message_data) if message_data['to'].present?
      send_slack_message(message_data) if ENV['SLACK_API_KEY'].present?
    end

    def send_slack_message(message_data)
      SlackClient.new(ENV['SLACK_API_KEY']).notify_content(message_data['body'])
    end

    def send_mail(message_data)
      mail_options = Messagist::Mailer.new(message_data).options
      message_template = File.read(File.join(__dir__, "views", "message.erb"))
      mail_options[:body] = ERB.new(message_template).result(OpenStruct.new(message: message_data).instance_eval { binding })
      Pony.append_inputs if ENV['RACK_ENV'] == 'development'
      Pony.mail(mail_options)
    end
  end
end
