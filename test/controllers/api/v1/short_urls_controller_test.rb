require 'test_helper'

class Api::V1::ShortUrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post '/api/v1/users/sign_up', user: { name: 'testuser', email: 'testuser@email.com', 
                                          password: '123456', password_confirmation: '123456' }

    @user = User.last
  end

  test "should be able to list all short urls" do
    post '/api/v1/short_urls', params: { short_url: { original_url: 'http://www.google.com' } }, 
                               headers: { 'X-Extra-Header' => @user.api_token } 

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
    post '/api/v1/short_urls', params: { short_url: { original_url: 'http://www.google.com' } }, 
                               headers: { 'X-Extra-Header' => @user.api_token } 

    url = ShortUrl.last

    get "/api/v1/short_urls/#{url.id}", headers: { 'X-Extra-Header' => @user.api_token }, as: :json

    assert_equal 1, url.reload.visits.count
  end

  test "should update short_url" do
    post '/api/v1/short_urls', params: { short_url: { original_url: 'http://www.google.com' } }, 
                               headers: { 'X-Extra-Header' => @user.api_token } 
    url = ShortUrl.last

    put "/api/v1/short_urls/#{url.id}", params: { short_url: { original_url: 'http://www.yahoo.com' } }, 
                                          headers: { 'X-Extra-Header' => @user.api_token } 

    assert_equal 'http://www.yahoo.com', url.reload.original_url
  end

  test "should destroy short_url" do
    post '/api/v1/short_urls', params: { short_url: { original_url: 'http://www.google.com' } }, 
                               headers: { 'X-Extra-Header' => @user.api_token } 
    url = ShortUrl.last

    delete "/api/v1/short_urls/#{url.id}", headers: { 'X-Extra-Header' => @user.api_token } 

    refute ShortUrl.where(id: url.id).first
  end
end
