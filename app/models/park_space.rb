class ParkSpace < ApplicationRecord
  validates :latitude, presence: true
  validates :longitude, presence: true

  belongs_to :user
  has_many :vehicles, dependent: :destroy
  has_many :park_vehicles, dependent: :destroy

  accepts_nested_attributes_for :vehicles, allow_destroy: true

   # Add geocoding functionality to ParkSpace model
   geocoded_by :location
   after_validation :geocode, if: :will_save_change_to_location?

   def distance_from(latitude, longitude)
    Haversine.distance(latitude, longitude, self.latitude, self.longitude).to_km
  end
end
