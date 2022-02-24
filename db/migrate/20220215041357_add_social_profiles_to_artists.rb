class AddSocialProfilesToArtists < ActiveRecord::Migration[6.1]
  def change
    rename_column :artists, :instagram_handle, :instagram
    add_column :artists, :facebook, :string, before: :instagram
    add_column :artists, :tiktok, :string, after: :instagram
  end
end
