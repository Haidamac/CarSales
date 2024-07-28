module Admin
  class CarsController < ApplicationController
    before_action :set_car, only: %i[show edit update]
    before_action :authorize_policy

    def index
      @cars = Car.all
      authorize @cars
    end

    def show
      authorize @car
    end

    def edit
      authorize @car
    end

    def update
      authorize @car
      if @car.update(car_params)
        redirect_to admin_car_path(@car), notice: 'Car status was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_car
      @car = Car.find(params[:id])
    end

    def car_params
      params.require(:car).permit(:status)
    end

    def authorize_policy
      authorize Car
    end
  end
end
