class Person < ApplicationRecord
  validates :name, presence: true
  validates :link, presence: true

  serialize :info, JSON
end
