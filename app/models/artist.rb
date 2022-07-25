class Artist < ApplicationRecord
    # not all artists are required to work with studios, allows for independent artists
    belongs_to :studio, optional: true
    has_many :reservations
    has_many_attached :artist_artwork, service: :amazon_artists
    has_one_attached :artist_profile, service: :amazon_artists
    validates :artist_artwork, file_content_type: { allow: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], message: 'must be file type gif, png, jpg, or jpeg' }, file_size: { less_than: 10.megabytes , message: 'must be less than 10MB in size' }
    validates :name, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" } 
    validates :email, uniqueness: true, on: :create, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/, message:  "must contain valid format" }
    validates :phone, uniqueness: true, length: { minimum: 12, maximum: 12, message: "number must be 10 digits long" }, if: -> { phone? }
    validates :city, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
    
    # multisearch ability by city + styles
    include PgSearch::Model
    pg_search_scope :search_by_city,
    against: :city
    pg_search_scope :search_by_styles,
    against: :styles,
    using: {
      tsearch: { any_word: true }
    }
end
