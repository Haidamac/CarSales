module Admin
  class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request, only: %i[new create]
    before_action :current_user, except: %i[create new]

    def new; end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = jwt_encode(user_id: user.id)
        cookies[:jwt] = {
          value: token,
          httponly: true,
          secure: Rails.env.production?,
          expires: 7.days.from_now
        }
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Logged in successfully'
        return
      else
        flash.now[:alert] = 'Invalid email or password'
        render :new
      end
    end

    def destroy
      cookies.delete(:jwt)
      session[:user_id] = nil
      redirect_to root_path, notice: 'Logged out successfully'
    end
  end
end
