class ParkVehicle < ApplicationRecord
  belongs_to :park_space
   # Method to set hourly_rate based on vehicle_name
   before_save :apply_hourly_rate

   enum vehicle_name: { car: 0, bike: 1 }
  def apply_hourly_rate
    self.hourly_rate = park_space.vehicles.find_by(vehicle_name: self.vehicle_name).hourly_rate if vehicle_name.present?
  end
end
