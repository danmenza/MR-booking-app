class Reservation < ApplicationRecord
    belongs_to :artist
    belongs_to :user
    has_many_attached :artwork, service: :amazon_users
    has_many_attached :body_area, service: :amazon_users
    validates :artwork, file_content_type: { allow: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], message: 'must be file type gif, png, jpg, or jpeg' }, file_size: { less_than: 10.megabytes , message: 'must be less than 10MB in size' } 
    validates :body_area, file_content_type: { allow: ['image/gif', 'image/png', 'image/jpg', 'image/jpeg'], message: 'must be file type gif, png, jpg, or jpeg' }, file_size: { less_than: 10.megabytes , message: 'must be less than 10MB in size' } 
end
