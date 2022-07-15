class AddBioToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :bio, :text
    add_column :studios, :bio, :text
  end
end
