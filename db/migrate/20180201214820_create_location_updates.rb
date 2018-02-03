class CreateLocationUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :location_updates do |t|
      t.decimal :latitude, precision: 9, scale: 6, null: false
      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.datetime :recorded_at, null: false
      t.float :accuracy
      t.float :altitude

      t.timestamps
    end
  end
end
