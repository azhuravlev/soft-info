class Tool < ApplicationRecord
  validates :name, presence: true
  validates :repo_url, presence: true

  after_create :notify_add
  after_update :notify_changes

  private

  def notify_add
    NotificationClient.new.notify_add(self)
  end

  def notify_changes
    NotificationClient.new.notify_changes(self)
  end
end