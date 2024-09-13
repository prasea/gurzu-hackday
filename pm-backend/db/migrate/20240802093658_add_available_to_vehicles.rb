class AddAvailableToVehicles < ActiveRecord::Migration[7.2]
  def change
    add_column :vehicles, :available, :integer, default: 0
  end
end
