class AddReferencesToStudiosAndArtists < ActiveRecord::Migration[6.1]
  def change
    add_reference :artists, :studio, null: true, foreign_key: true
  end
end
