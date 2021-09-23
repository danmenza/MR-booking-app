class Artist < ApplicationRecord
    has_many :reservations
    has_many_attached :artist_artwork, service: :amazon_artists
end
