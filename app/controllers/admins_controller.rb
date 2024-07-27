class AdminsController < ApplicationController
  before_action :authorize_policy

  def create_admin
    @new_admin = User.new(user_params)

    if @new_admin.save
      @new_admin.admin!
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end

  def authorize_policy
    authorize User
  end
end
