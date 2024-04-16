class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    
         
  validates :first_name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :dob_should_be_greater_than_today


  enum gender: [ :male, :female, :other ]
  enum role: [:super_admin, :artist_manager, :artist]

  def dob_should_be_greater_than_today
    errors.add(:dob, "should be a past date") if dob.present? && dob > Date.today
  end
  
end
