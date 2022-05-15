class UpdateArtistAndStudioAttributes < ActiveRecord::Migration[6.1]
  def change
    remove_column :artists, :address
    add_column :studios, :email, :string
  end
end
