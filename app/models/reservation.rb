class Reservation < ApplicationRecord
    belongs_to :artist
    belongs_to :user
    has_many_attached :artwork, service: :amazon_users
end
