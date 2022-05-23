class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reservations, dependent: :destroy
  validates :first_name, on: [:create, :update], format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
  validates :last_name, on: [:create, :update], format: { with: /\A[a-zA-Z ]+\z/, message:  "must only contain letters" }
  validates :email, on: [:create, :update], uniqueness: true
  def phone=(value)
    super((value.blank?) ? nil : (12 == value.length) ? "+1#{ value.gsub(/[^0-9]/, "") }" : "+1 (#{phone[2..4]}) #{phone[5..7]} - #{phone[8..-1]}") 
  end
end
