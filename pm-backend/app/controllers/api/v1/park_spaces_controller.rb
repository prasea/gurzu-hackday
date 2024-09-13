# class Api::V1::ParkSpacesController < ApplicationController
#   def park_space
#     location = params[:location]
#     if location.blank?
#       render json: { error: "Location parameter is required" }, status: :bad_request
#       return
#     end

#     # Geocode the location to get latitude and longitude
#     results = Geocoder.search(location)

#     if results.empty?
#       render json: { error: "Geocoder not searching! Location not found" }, status: :not_found
#       return
#     end

#     coordinates = results.first.coordinates # [latitude, longitude]
#     latitude, longitude = coordinates

#     # Find nearby park spaces
#     park_spaces = ParkSpace.near([ latitude, longitude ], 10, units: :km).includes(:vehicles) # 10 km radius

#     # Render the park spaces with associated vehicles
#     # render json: park_spaces.as_json(include: { vehicles: { except: :id } }, except: :id)
#     render json: park_spaces.to_json(include: :vehicles)
#   end
# end

# app/controllers/api/v1/park_spaces_controller.rb
class Api::V1::ParkSpacesController < ApplicationController
  before_action :authenticate_user!


  def index
    if ParkSpace.count.zero? 
      render json: {park_spaces: 0, message: 'No parking space created yet !'}, status: :ok
    else 
      render json: {park_spaces: ParkSpace.all }, status: :ok
    end
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
      render json: {message: 'Park space was successfully created.', park_space: @park_space}, status: :created
    else
      render json: {message: 'Failed to create park space.', errors: @park_space.errors.full_messages.join(',')}, status: :unprocessable_entity
    end
  end

  def edit 
    @park_space = ParkSpace.find(params[:id])  
  end

  def update 
    @park_space = ParkSpace.find(params[:id])
    if @park_space.update(park_space_params)
      render json: {message: 'Park space was successfully updated.', park_space: @park_space}, status: :ok
    else 
      render json: {message: 'Failed to create park space.', errors: @park_space.errors.full_messages.join(',')}, status: :unprocessable_entity
    end
  end


  def park_space
    location = params[:location]
    if location.blank?
      render json: { error: "Location parameter is required" }, status: :bad_request
      return
    end

    # Geocode the location to get latitude and longitude
    results = fetch_coordinates(location)
    if results.empty?
      render json: { error: "Location not found" }, status: :not_found
      return
    end

    coordinates = results.first
    latitude, longitude = coordinates
    latitude, longitude = [ 27.6758786, 85.3854371 ] if coordinates.blank?

    # Find nearby park spaces
    park_spaces = ParkSpace.all.select do |park_space|
      next if park_space.latitude.nil? || park_space.longitude.nil?

      distance = Haversine.distance(latitude, longitude, park_space.latitude, park_space.longitude).to_km
      distance <= 10 # 10 km radius
    end.compact

    render json: park_spaces.to_json(include: :vehicles)
  end

  private

  def fetch_coordinates(location)
    # Example static lookup
    locations = {
      "balkumari" => [ 27.671189199022322, 85.33709456556089 ]
      # Add more locations here
    }
    [ locations[location] || [] ]
  end


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
