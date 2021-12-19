class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reservations
  validates :first_name, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" } 
  validates :last_name, format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
  validates :email, uniqueness: true, on: :create
end
