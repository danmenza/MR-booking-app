class AddStudioToArtist < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :studio, :string, after: :styles
    change_column :artists, :minimum, :decimal, after: :studio
  end
end
