class UpdateAuthTokenExpiresAtToDateTime < ActiveRecord::Migration[6.1]
  def change
    remove_column :artists, :auth_token_expires_at
    add_column :artists, :auth_token_expires_at, :datetime
  end
end
