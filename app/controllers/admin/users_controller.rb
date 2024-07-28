module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :destroy]
    before_action :authorize_policy

    def index
      @users = User.all
      authorize @users
    end

    def show
      authorize @user
    end

    def destroy
      authorize @user

      @user.destroy
      redirect_to admin_users_path, notice: 'User was successfully destroyed.'
    end

    def new_admin; end

    def create_admin
      @new_admin = User.new(user_params)
      if @new_admin.save
        @new_admin.admin!
        redirect_to admin_users_path, notice: 'Admin was successfully created.'
      else
        render :new
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :email, :password)
    end

    def authorize_policy
      authorize User
    end
  end
end
