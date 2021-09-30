class AddColorAndBodyImageToReservations < ActiveRecord::Migration[6.1]
  def change
    rename_column :reservations, :tattoo_location, :tattoo_placement
    rename_column :reservations, :style, :description
    add_column :reservations, :color, :boolean
  end
end
