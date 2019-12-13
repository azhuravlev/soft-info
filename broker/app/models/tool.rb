class Tool < ApplicationRecord
  validates :name, presence: true
  validates :repo_url, presence: true
end