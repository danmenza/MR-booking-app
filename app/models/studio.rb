class Studio < ApplicationRecord
    # has_many :artists
    validates :address, format: { with: /\A[a-zA-z0-9. \s]+\z/, message:  "must contain valid format" }
    validates :city, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
end
