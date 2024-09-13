class AddStatusToParkVehicles < ActiveRecord::Migration[7.2]
  def change
    add_column :park_vehicles, :status, :boolean
  end
end
