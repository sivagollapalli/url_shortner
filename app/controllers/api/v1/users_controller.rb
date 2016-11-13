module Api::V1
  class UsersController < ApiController

    # POST /api/v1/users/sign_up
    def sign_up 
      user = User.new(user_params)

      if user.save
        render json: { success: 'User successfully signedup' }, status: :created
      else
        render json: { error: user.errors }, status: :unprocessable_entity
      end
    end

    # POST /api/v1/users/sign_in
    def sign_in
      user = User.find_by(email: params.dig(:user, :email)).try(:authenticate, params.dig(:user, :password))

      if user
        render json: user.as_json(only: [:id, :name, :email, :api_token]), status: :ok
      else
        render json: { error: 'Invalid username or password' }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit!
    end
  end
end
