class Studio < ApplicationRecord
    has_many :artists
    has_one_attached :studio_image, service: :amazon_studios
    validates :studio_image, file_content_type: { allow: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], message: 'must be file type gif, png, jpg, or jpeg' }, file_size: { less_than: 10.megabytes , message: 'must be less than 10MB in size' } 
    validates :address, format: { with: /\A[a-zA-z0-9. \s]+\z/, message:  "must contain valid format" }
    validates :city, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
    validates :phone, length: { minimum: 12, maximum: 12 }

    # multisearch ability by city + styles
    include PgSearch::Model
    pg_search_scope :search_by_city,
    against: [ :city ],
    using: {
      tsearch: { prefix: true }
    }
    geocoded_by :address
    after_validation :geocode, if: :will_save_change_to_address?
end
