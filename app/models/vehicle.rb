class Vehicle < ApplicationRecord
  before_save :set_initial_available, if: :new_record?

  belongs_to :park_space
  enum vehicle_name: { car: 0, bike: 1 }

  # Set available to match capacity when a new vehicle is created
  def set_initial_available
    self.available = self.capacity
  end
end
