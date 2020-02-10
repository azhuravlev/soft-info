class SlackClient

  def initialize(api_key = nil)
    @api_key = api_key || ENV['SLACK_API_TOKEN']
  end

  def notify_content(content)
    return unless @api_key.present?
    return unless (channel = ENV['SLACK_CHANNEL']).present?
    client.chat_postMessage(channel: channel, text: content)
  end

  def client
    @client ||= Slack::Web::Client.new(token: @api_key)
  end
end

