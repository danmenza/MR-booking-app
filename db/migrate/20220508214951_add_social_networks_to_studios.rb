class AddSocialNetworksToStudios < ActiveRecord::Migration[6.1]
  def change
    add_column :studios, :instagram, :string
    add_column :studios, :facebook, :string
    add_column :studios, :tiktok, :string
  end
end
