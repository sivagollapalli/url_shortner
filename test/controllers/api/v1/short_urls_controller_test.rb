require 'test_helper'

class Api::V1::ShortUrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "should be able to list all short urls" do
    create(:short_url, user: @user)

    get '/api/v1/short_urls',headers: { 'X-Extra-Header' => @user.api_token } 

    res = JSON.parse(response.body).first

    assert_equal 'http://www.google.com', res['original_url']
    assert_equal @user.id, res['user_id']
  end

  test 'should not able to create short url if url is empty' do
    post '/api/v1/short_urls', params: { short_url: { original_url: '' } }, 
                               headers: { 'X-Extra-Header' => @user.api_token } 

    assert_equal ["can't be blank"], JSON.parse(response.body).dig('original_url')
  end

  test "should geolocate short url" do
    url = create(:short_url, user: @user) 

    get "/api/v1/short_urls/#{url.id}", headers: { 'X-Extra-Header' => @user.api_token }, as: :json

    assert_equal 1, url.reload.visits.count
    assert_equal 1, url.reload.visits_count

    get "/api/v1/short_urls/#{url.id}", headers: { 'X-Extra-Header' => @user.api_token }, as: :json
    assert_equal 2, url.reload.visits_count
  end

  test "should update short_url" do
    url = create(:short_url, user: @user) 

    put "/api/v1/short_urls/#{url.id}", params: { short_url: { original_url: 'http://www.yahoo.com' } }, 
                                          headers: { 'X-Extra-Header' => @user.api_token } 

    assert_equal 'http://www.yahoo.com', url.reload.original_url
  end

  test "should destroy short_url" do
    url = create(:short_url, user: @user) 

    delete "/api/v1/short_urls/#{url.id}", headers: { 'X-Extra-Header' => @user.api_token } 

    refute ShortUrl.where(id: url.id).first
  end
end
