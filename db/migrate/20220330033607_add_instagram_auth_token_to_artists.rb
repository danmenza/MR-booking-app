class AddInstagramAuthTokenToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :instagram_auth_token, :string, after: :instagram
  end
end
