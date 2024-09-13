class CreateParkVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :park_vehicles do |t|
      t.integer :vehicle_name
      t.integer :hourly_rate
      t.string :vehicle_number
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :cost
      t.references :park_space, null: false, foreign_key: true
      t.boolean :status

      t.timestamps
    end
  end
end
