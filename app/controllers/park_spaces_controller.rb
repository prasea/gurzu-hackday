class ParkSpacesController < ApplicationController
  before_action :authenticate_user!

  def index
    @park_spaces = ParkSpace.all
  end

  def new
    @park_space = ParkSpace.new
    @park_space.vehicles.build
    # 2.times { @park_space.vehicles.build }
  end

  def create
    @park_space = ParkSpace.new(park_space_params)
    @park_space.user = current_user
    # Geocode the location to get latitude and longitude if not supplied from form 
    if (!@park_space.latitude && !@park_space.longitude) 
      geocode_location(@park_space)
    end

    if @park_space.save
      redirect_to park_spaces_path,  notice: "Park space was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
    @park_space = ParkSpace.find(params[:id])  
  end

  def update 
    @park_space = ParkSpace.find(params[:id])
    if @park_space.update(park_space_params)
      # redirect_to park_space_path(@park_space)
      redirect_to park_spaces_path, notice: "Park space updated !"
    else 
      render :edit, status: :unprocessable_entity, notice: 'Unable to update park space'
    end
  end




  private
  def park_space_params
    params.require(:park_space).permit(:name, :location, :latitude, :longitude,  :user_id,
                                       vehicles_attributes: [ :id, :vehicle_name, :capacity, :hourly_rate, :status, :_destroy ])
  end

  def geocode_location(park_space)
    results = Geocoder.search(park_space.location)
    if results.any?
      coordinates = results.first.coordinates
      park_space.latitude = coordinates[0]
      park_space.longitude = coordinates[1]
    else
      # Handle cases where location cannot be geocoded, e.g., set defaults or raise an error
      park_space.latitude = 26.6686775
      park_space.longitude = 87.6767778
    end
  end
end
