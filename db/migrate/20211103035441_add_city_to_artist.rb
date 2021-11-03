class AddCityToArtist < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :city, :string, after: :styles
  end
end
