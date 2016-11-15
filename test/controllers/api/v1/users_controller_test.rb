require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "user should be able to signup" do
    post '/api/v1/users/sign_up', user: { name: 'testuser', email: 'testuser@email.com', 
                                          password: '123456', password_confirmation: '123456' }

    user = User.last

    assert_equal 'testuser', user.name 
    assert_equal 'testuser@email.com', user.email
    assert user.password_digest
    assert user.api_token
    assert_equal 'User successfully signedup', JSON.parse(response.body).dig('success')
  end

  test 'shouldnt signup if name is blank' do
    post '/api/v1/users/sign_up', user: { name: '', email: 'testuser@email.com', 
                                          password: '123456', password_confirmation: '123456' }
    res = JSON.parse(response.body)
    assert_equal ["can't be blank"], res.dig('error', 'name')
  end

  test 'shouldnt signup if email is blank' do
    post '/api/v1/users/sign_up', user: { name: 'testuser', email: '', 
                                          password: '123456', password_confirmation: '123456' }
    res = JSON.parse(response.body)
    assert_equal ["can't be blank", 'is invalid'], res.dig('error', 'email')
  end

  test 'registered user should be able to signup' do
    user = create(:user)

    post '/api/v1/users/sign_in', user: { email: user.email, 'password': '123456' }

    res = JSON.parse(response.body)

    assert_equal user.email, res['email']
    assert_equal user.name, res['name']
    assert res['api_token']
  end

  test 'should not able to login if email or password didnt match' do
    create(:user)
    post '/api/v1/users/sign_in', user: { email: 'testuser@emal.com', 'password': '12345' }

    res = JSON.parse(response.body)

    assert_equal 'Invalid username or password', res['error']
  end
end
