class AddArtistToReservation < ActiveRecord::Migration[6.1]
  def change
    add_reference :reservations, :artist, null: false, foreign_key: true
  end
end
