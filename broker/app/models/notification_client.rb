class NotificationClient
  def initialize
    @sendgrid_client = SendgridClient.new(ENV['SENDGRID_API_KEY']) if ENV['SENDGRID_API_KEY'].present?
    @slack_client = SlackClient.new(ENV['SLACK_API_KEY']) if ENV['SLACK_API_KEY'].present?
  end

  def notify_add(soft)
    @sendgrid_client&.notify_add(soft)
    @slack_client&.notify_add(soft)
  end

  def notify_changes(soft)
    @sendgrid_client&.notify_changes(soft)
    @slack_client&.notify_changes(soft)
  end
end