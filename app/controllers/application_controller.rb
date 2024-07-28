class ApplicationController < ActionController::Base
  include JsonWebToken
  include Authenticate
  include Pundit::Authorization

  protect_from_forgery with: :exception
  before_action :authenticate_request

  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ArgumentError, with: :invalid_argument

  private

  def authenticate_request
    token = cookies[:jwt]
    if token
      begin
        decoded = jwt_decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue JWT::DecodeError
        redirect_to login_path, alert: 'Invalid token. Please log in again.'
      rescue ActiveRecord::RecordNotFound
        redirect_to login_path, alert: 'User not found. Please log in again.'
      end
    else
      redirect_to login_path, alert: 'Please log in to access this page.'
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def pundit_user
    @current_user
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
  end

  def record_not_found
    render json: { error: 'record_not_found' }, status: :not_found
  end

  # def invalid_argument
  #   render json: { error: 'invalid argument' }, status: :unprocessable_entity
  # end
end
