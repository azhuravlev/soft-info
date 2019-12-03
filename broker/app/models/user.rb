class User < ApplicationRecord
  before_validation :set_role
  before_create :initialize_token

  private

  def set_role
    self.role ||= 'user'
  end

  def initialize_token
    generate_token if token.blank?
  end

  def generate_token
    self.token = Digest::SHA2.hexdigest("--#{Time.now.to_f.to_s}--#{self.email}--#{self.role}--")
  end
end