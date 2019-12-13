class SlackClient

  def initialize(api_key = nil)
    @api_key = api_key || ENV['SLACK_API_TOKEN']
  end

  def notify_add(soft)
    notify_content "New soft #{soft.name} located at #{soft.url} was added"
  end

  def notify_changes(soft)
    notify_content "#{soft.name} located at #{soft.url} was changed"
  end

  private

  def notify_content(content)
    return unless @api_key.present?
    return unless (channel = ENV['SLACK_CHANNEL']).present?
    client.chat_postMessage(channel: channel, text: content)
  end

  def client
    @client ||= Slack::Web::Client.new(token: @api_key)
  end
end

