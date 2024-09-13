class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.string :vehicle
      t.integer :capacity
      t.integer :hourly_rate
      t.boolean :status
      t.references :park_space, null: false, foreign_key: true

      t.timestamps
    end
  end
end
