class CreateParkSpaces < ActiveRecord::Migration[7.2]
  def change
    create_table :park_spaces do |t|
      t.string :name
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
