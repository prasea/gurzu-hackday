class ChangeVehicleNameToInteger < ActiveRecord::Migration[7.2]
  def up
    # Convert existing values to integers, assuming they can be safely cast
    execute <<-SQL
      ALTER TABLE vehicles
      ALTER COLUMN vehicle_name
      TYPE integer
      USING vehicle_name::integer;
    SQL
  end

  def down
    # Revert back to string if needed
    execute <<-SQL
      ALTER TABLE vehicles
      ALTER COLUMN vehicle_name
      TYPE varchar
      USING vehicle_name::varchar;
    SQL
  end
end
