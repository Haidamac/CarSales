class CarsController < ApplicationController
  include Rails.application.routes.url_helpers
  include CarableUtilities

  skip_before_action :authenticate_request, only: %i[index show]
  before_action :current_user, only: %i[index show]
  before_action :authorize_policy
  before_action :set_car, only: :show
  before_action :edit_car, only: %i[edit update destroy]

  # GET /cars or /cars.json
  def index
    @cars = if params[:user_id].present?
              Car.filter_by_participant(params[:user_id])
            else
              Car.where(status: 'approved')
            end

    authorize @cars
  end

  # GET /cars/1 or /cars/1.json
  def show
    authorize @car
  end

  def new
    @car = Car.new
  end

  # POST /cars or /cars.json
  def create
    @car = current_user.cars.build(car_params)

    authorize @car

    respond_to do |format|
      if @car.save
        format.html { redirect_to car_url(@car), notice: 'Car was successfully created.' }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @car
  end

  # PATCH/PUT /cars/1 or /cars/1.json
  def update
    authorize @car

    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to car_url(@car), notice: 'Car was successfully updated.' }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1 or /cars/1.json
  def destroy
    authorize @car

    @car.destroy!
    respond_to do |format|
      format.html { redirect_to cars_url, notice: 'Car was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_car
    @car = policy_scope(Car).find(params[:id])
  end

  def edit_car
    @car = CarPolicy::EditScope.new(current_user, Car).resolve.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:brand, :car_model, :body, :mileage, :color, :price, :fuel, :year, :volume, images: [])
  end

  def edit_car_params
    params.permit(policy(@car).permitted_attributes)
  end

  def authorize_policy
    authorize Car
  end
end
