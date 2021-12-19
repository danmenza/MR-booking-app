class ArtistUpdateStylesField < ActiveRecord::Migration[6.1]
  def change
    remove_column :artists, :styles, :text
    add_column :artists, :styles, :text, array: true, default: []
  end
end
