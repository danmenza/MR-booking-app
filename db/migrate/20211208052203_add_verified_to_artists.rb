class AddVerifiedToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :verified, :boolean, default: false
  end
end
