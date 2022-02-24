class ChangeArtistStudioFieldName < ActiveRecord::Migration[6.1]
  def change
    rename_column :artists, :studio, :studio_name
  end
end
