require 'net/http'

class NotificationClient
  class << self
    def notify_add(soft)
      message = message_params("Soft #{soft.name} was added", "Soft #{soft.name} located at #{soft.repo_url} was added", soft)
      message[:to] = User.all.distinct.pluck(:email).sort
      message[:from] = 'soft-info@dev.com'
      send(message)
    end

    def notify_changes(soft)
      message = message_params("Soft #{soft.name}changed", "Soft #{soft.name} was changed", soft)
      message[:to] = User.where(role: 'admin').distinct.pluck(:email).sort
      message[:from] = 'soft-info@dev.com'
      send(message)
    end

    private

    def message_params(title, body, soft)
      {
          title: title,
          body: body,
          attrs: soft.as_json
      }
    end

    def send(message)
      return unless messagist_url = ENV.fetch('MESSAGIST_API_URL')
      uri = URI.join(messagist_url, '/v1/message')

      http = ::Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 60
      http.read_timeout = 120

      headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
      }

      request = Net::HTTP::Post.new(uri, headers).tap { |r| r.body = { message: message }.to_json }
      request.basic_auth(ENV.fetch('MESSAGIST_API_LOGIN'), ENV.fetch('MESSAGIST_API_PASS'))
      http.request(request)
    end
  end
end
