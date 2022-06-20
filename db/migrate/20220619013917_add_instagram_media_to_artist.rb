class AddInstagramMediaToArtist < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :instagram_media, :text, array: true, default: []
  end
end
