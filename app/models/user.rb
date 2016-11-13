class User < ApplicationRecord
  has_secure_password

  has_many :short_urls, dependent: :destroy

  validates :name, :email, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  before_create do |user|
    user.api_token = user.generate_api_key
  end

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_token: token)
    end
  end
end
