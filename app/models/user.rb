class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reservations, dependent: :destroy
  validates :first_name, on: [:create, :update], format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
  validates :last_name, on: [:create, :update], format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
  validates :email, on: [:create, :update], uniqueness: true

  # phone number formatter for saving to and reading from database due to devise user management
  def phone=(value)
    super((value.blank?) ? nil : (14 == value.length) ? "+1#{ value.gsub(/[^0-9]/, "") }" : "+1 #{value[2..4]}#{value[5..7]}#{value[8..-1]}") 
  end
end
