class Reservation < ApplicationRecord
    belongs_to :artist
    belongs_to :user
    has_many_attached :artwork, service: :amazon_users
    has_many_attached :body_area, service: :amazon_users
end
