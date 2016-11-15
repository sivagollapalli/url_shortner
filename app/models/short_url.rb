class ShortUrl < ApplicationRecord
  belongs_to :user
  has_many :visits, dependent: :destroy

  validates :original_url, :shorty, presence: true
  validates_uniqueness_of :shorty

  before_validation do |url|
    digest = Digest::MD5.hexdigest(original_url + rand(100000).to_s).slice(0..6) 
    url.shorty = HOST + '/' + digest
  end
end
