module Api::V1
  class ApiController < ApplicationController
    def authenticate
      api_key = request.headers['X-Extra-Header']
      @user = User.where(api_token: api_key).first if api_key

      unless @user
        head status: :unauthorized
        return false
      end
    end

    def current_user
      @user
    end
  end
end
