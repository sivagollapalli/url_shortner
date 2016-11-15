require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase
  test 'should generate short url' do
    assert_not_equal nil, create(:short_url, user: create(:user)).shorty
  end

  test 'should generate new shorty once original url has been updated' do
    url = create(:short_url, user: create(:user))
    shorty1 = url.shorty
    url.update_attributes(original_url: 'http://www.yahoo.com')
    assert_not_equal shorty1, url.reload.shorty
  end

  test 'no two short urls should be same' do
    url1 = create(:short_url, user: create(:user))
    url2 = create(:short_url, user: create(:user))

    assert_not_equal url1.shorty, url2.shorty
  end
end
