class AddMinimumToArtist < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :minimum, :decimal, precision: 10, scale: 2
  end
end
