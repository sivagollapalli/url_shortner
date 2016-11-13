class AddUserRefToShortUrl < ActiveRecord::Migration[5.0]
  def change
    add_reference :short_urls, :user, foreign_key: true
  end
end
