class AddTokenExpiresAtToArtists < ActiveRecord::Migration[6.1]
  def change
    add_column :artists, :auth_token_expires_at, :integer, after: :instagram_auth_token
  end
end
