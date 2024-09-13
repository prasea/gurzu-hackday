class RenameVehcileToVehcileName < ActiveRecord::Migration[7.2]
  def change
    rename_column :vehicles, :vehicle, :vehicle_name
  end
end
