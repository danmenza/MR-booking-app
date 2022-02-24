class Artist < ApplicationRecord
    belongs_to :studio, optional: true
    has_many :reservations
    has_many_attached :artist_artwork, service: :amazon_artists
    has_one_attached :artist_profile, service: :amazon_artists
    validates :artist_artwork, presence: true, file_content_type: { allow: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], message: 'must be file type gif, png, jpg, or jpeg' }, file_size: { less_than: 10.megabytes , message: 'must be less than 10MB in size' } 
    validates :name, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" } 
    validates :email, uniqueness: true, on: :create, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/, message:  "must contain valid format" }
    validates :address, format: { with: /\A[a-zA-z0-9. \s]+\z/, message:  "must contain valid format" }
    validates :city, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" } 
    include PgSearch::Model
    pg_search_scope :search_by_city,
    against: [ :city, :styles ],
    using: {
      tsearch: { prefix: true }
    }
end
