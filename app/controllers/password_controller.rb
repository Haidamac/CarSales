class PasswordController < ApplicationController
  skip_before_action :authenticate_request, except: :update

  # GET /forgot_password
  def new_forgot; end

  # POST /forgot_password
  def forgot
    if params[:email].blank?
      flash.now[:alert] = 'Email is not specified'
      render :new_forgot, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.generate_password_token!
      PasswordResetMailer.with(user:).password_reset.deliver_later
      flash[:notice] = 'Password recovery instructions have been sent to your email address'
      redirect_to login_path
    else
      flash.now[:alert] = 'Email address not found. Please check and try again.'
      render :new_forgot, status: :not_found
    end
  end

  # GET /reset_password?token=your_token
  def new_reset
    @token = params[:token]
  end

  # POST /reset_password
  def reset
    token = params[:token]

    if params[:password].blank?
      flash.now[:alert] = 'The password is not specified'
      render :new_reset, status: :unprocessable_entity
      return
    end

    user = User.find_by(reset_password_token: token)

    if user&.password_token_valid?
      if user.reset_password!(params[:password])
        flash[:notice] = 'Password changed successfully'
        redirect_to login_path
      else
        flash.now[:alert] = user.errors.full_messages.join(', ')
        render :new_reset, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'The link is invalid or has expired.'
      render :new_reset, status: :not_found
    end
  end

  # GET /update_password
  def edit; end

  # PATCH /update_password
  def update
    user = @current_user
    old_password = params[:old_password]
    new_password = params[:new_password]
    confirm_password = params[:confirm_password]

    if user&.authenticate(old_password)
      if new_password == confirm_password
        user.update(password: new_password)
        flash[:notice] = 'Password updated'
        redirect_to root_path
      else
        flash.now[:alert] = 'Error occured'
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = 'Old password incorrect'
      render :edit, status: :unprocessable_entity
    end
  end
end

