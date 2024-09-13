# app/controllers/park_vehicles_controller.rb
class ParkVehiclesController < ApplicationController
  before_action :set_park_space
  before_action :set_park_vehicle, only: [  :edit, :update, :destroy ]

  def index
    @park_vehicles = @park_space.park_vehicles
  end

  def new
    @park_vehicle = @park_space.park_vehicles.new
  end

  def create
    @park_vehicle = @park_space.park_vehicles.new(park_vehicle_params)
    @park_vehicle.hourly_rate = Vehicle.find_by(vehicle_name: @park_vehicle.vehicle_name).hourly_rate
    if @park_vehicle.save
      redirect_to park_space_park_vehicles_path, notice: "Park vehicle was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    @park_vehicle.ends_at = park_vehicle_params[:ends_at]
    duration = (@park_vehicle.ends_at - @park_vehicle.starts_at) / 1.hour
    @park_vehicle.cost = (duration * @park_vehicle.hourly_rate).round
    @park_vehicle.status = false
    if @park_vehicle.update(park_vehicle_params)
      redirect_to @park_space, notice: "Park vehicle was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @park_vehicle.status == false
      @park_vehicle.destroy
      redirect_to @park_space, notice: "Park vehicle was successfully deleted."
    else
      redirect_to @park_space, alert: "Cannot delete an active park vehicle."
    end
  end

  private

  def set_park_space
    @park_space = ParkSpace.find(params[:park_space_id])
  end

  def set_park_vehicle
    @park_vehicle = @park_space.park_vehicles.find(params[:id])
  end

  def park_vehicle_params
    params.require(:park_vehicle).permit(:vehicle_name, :hourly_rate, :vehicle_number, :status,  :starts_at, :ends_at, :cost, :status)
  end
end
