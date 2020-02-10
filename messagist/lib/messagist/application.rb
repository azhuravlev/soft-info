# frozen_string_literal: true

require File.join(__dir__, '..', 'messagist.rb')

require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/namespace'
require 'sinatra/json'
require_relative 'mailer'
require_relative 'slack_client'

module Messagist
  class Application < ::Sinatra::Base
    register ::Sinatra::Namespace

    configure do
      set :show_exceptions, false
      enable :logging
      use Rack::CommonLogger, STDOUT
      use Rack::Auth::Basic, "Deny access" do |login, password|
        login == ENV['API_LOGIN'] && password == ENV['API_PASS']
      end
    end

    get '/status' do
      json status: 'ok'
    end

    post '/v1/message' do
      message_data = JSON.parse(request.body.read)['message']
      send_message(message_data)
      json 'ok',  status: 'ok'
    rescue StandardError => e
      json({ error: e.inspect }, status: 500)
    end

    private

    def send_message(message_data)
      send_mail(message_data) if message_data['to'].present?
      send_slack_message(message_data) if ENV['SLACK_API_KEY'].present?
    end

    def send_slack_message(message_data)
      SlackClient.new(ENV['SLACK_API_KEY']).notify_content(message_data['body'])
    end

    def send_mail(message_data)
      @message = message_data
      mail_options = Messagist::Mailer.new(message_data).options
      mail_options[:body] = erb(:message)
      Pony.append_inputs if ENV['RACK_ENV'] == 'development'
      Pony.mail(mail_options)
    end
  end
end
