class AddLatitudeAndLongitudeToParkSpaces < ActiveRecord::Migration[7.2]
  def change
    add_column :park_spaces, :latitude, :float
    add_column :park_spaces, :longitude, :float
  end
end
