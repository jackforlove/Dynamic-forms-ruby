class ApiKey < ApplicationRecord
  belongs_to :user

  before_create :generate_access_token

  enum source: {web: 0, app: 1}

  def update_access_token
    generate_access_token
    self.save
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
