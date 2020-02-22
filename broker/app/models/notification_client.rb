require 'net/http'

class NotificationClient
  class << self
    def notify_add(soft)
      message = message_params("Soft #{soft.name} was added", "Soft #{soft.name} located at #{soft.repo_url} was added", soft)
      message[:to] = User.all.distinct.pluck(:email).sort
      message[:from] = 'soft-info@dev.com'
      Sneakers.publish(soft.to_json, to_queue: "tools")
      Sneakers.publish(message.to_json, to_queue: "tools")
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
      Sneakers.publish(message.to_json, to_queue: "tool_messages")
    end
  end
end
