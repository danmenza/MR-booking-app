class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.datetime :appt_date
      t.string :tattoo_location
      t.boolean :cover_up
      t.string :style

      t.timestamps
    end
  end
end
