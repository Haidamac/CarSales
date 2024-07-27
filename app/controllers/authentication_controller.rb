class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
  before_action :current_user, except: :login

  def new; end

  # Post api/v1/auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
       token = jwt_encode(user_id: @user.id)
       response.set_header('Authorization', "Bearer #{token}")
       redirect_to root_path
    else
      flash.now[:alert] = 'Inccorect email or password'
      render :new, status: :unauthorized
    end
  end
end
