require 'sendgrid-ruby'

class SendgridClient
  include SendGrid

  def initialize(api_key = nil)
    @api_key = api_key || ENV['SENDGRID_API_KEY']
  end

  def notify_add(soft)
    return unless @api_key.present?
    from = Email.new(email: 'soft-info@dev.com')
    subject = "Soft #{soft.name} was added"
    content = Content.new(type: 'text/plain', value: "New soft #{soft.name} located at #{soft.url} was added")

    User.where(role: 'admin').each do |admin|
      to = Email.new(email: admin.email)
      sg.client.mail._('send').post(request_body: SendGrid::Mail.new(from, subject, to, content).to_json)
    end
  end

  def notify_changes(soft)
    return unless @api_key.present?
    from = Email.new(email: 'soft-info@dev.com')
    subject = "Soft #{soft.name} changed"
    content = Content.new(type: 'text/plain', value: "#{soft.name} located at #{soft.url} was changed")

    User.where(role: 'admin').each do |admin|
      to = Email.new(email: admin.email)
      sg.client.mail._('send').post(request_body: SendGrid::Mail.new(from, subject, to, content).to_json)
    end
  end

  private

  def sg
    @sg ||= SendGrid::API.new(api_key: @api_key)
  end
end

