class RemoveStudioNameFromArtists < ActiveRecord::Migration[6.1]
  def change
    remove_column :artists, :studio_name
  end
end
