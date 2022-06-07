class Api::V1::ApplicationApiController < ActionController::API
  # before_action :authenticate_api_user
  #
  # def authenticate_api_user
  #   user = User.find_by_email(user_params[:email])
  #   if user
  #     if user.valid_password?(user_params[:password])
  #       @user = user
  #     else
  #       render json: {errors: ["Wrong password by user: #{user_params[:email]}"]}, status: :unauthorized
  #     end
  #   else
  #     render json: {errors: ["Not found user with email: #{user_params[:email]}"]}, status: :unauthorized
  #   end
  # end
  #
  # def current_user
  #   @user
  # end
  #
  # private
  #
  #   def user_params
  #     params.permit(:email, :password)
  #   end

end