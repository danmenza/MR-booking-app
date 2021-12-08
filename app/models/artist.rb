class Artist < ApplicationRecord
    has_many :reservations
    has_many_attached :artist_artwork, service: :amazon_artists
    include PgSearch::Model
    pg_search_scope :search_by_city,
    against: [ :city, :styles ],
    using: {
      tsearch: { prefix: true }
    }
end
