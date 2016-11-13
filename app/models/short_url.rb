class ShortUrl < ApplicationRecord
  belongs_to :user
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true

  before_save do |url|
    begin
      url.shorty = Bitly.client.shorten(original_url)
    rescue Exception => e
      Rails.logger.info e.backtrace.join("\n")
    end
  end
end
