class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :authorize_policy
  before_action :set_user, only: [:show]
  before_action :edit_user, only: %i[update destroy]

  # GET api/v1/users
  def index
    @users = if params[:role].present?
               User.role_filter(params[:role])
             else
               User.all
             end

    authorize @users
  end

  # GET api/v1/users/{name}
  def show
    authorize @user
  end

  def new
    @user = User.new(user_params)

    authorize @user
  end

  # POST api/v1/users
  def create
    authorize @user

    if @user.save
      format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  def edit
    authorize @user
  end

  # PUT/PATCH api/v1/users/{id}
  def update
    authorize @user

    respond_to do |format|
      if @user.update(car_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE api/v1/users/{id}
  def destroy
    authorize @user

    @user.destroy!
    respond_to do |format|
      format.html { redirect_to user_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = policy_scope(User).find(params[:id])
  end

  def edit_user
    @user = UserPolicy::EditScope.new(current_user, User).resolve.find(params[:id])
  end

  def user_params
    params.permit(:name, :email, :password, :phone)
  end

  def edit_user_params
    params.permit(policy(@user).permitted_attributes)
  end

  def authorize_policy
    authorize User
  end
end
