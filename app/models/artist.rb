class Artist < ApplicationRecord

  has_many :songs, dependent: :destroy
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :dob_should_be_greater_than_today
  validate :first_release_year_not_greater_than_today

  enum gender: [ :male, :female, :other ]


  def dob_should_be_greater_than_today
    errors.add(:dob, "should be a past date") if dob.present? && dob > Date.today
  end

  def first_release_year_not_greater_than_today
    errors.add(:first_release_year, "should be not be future year") if first_release_year.present? && first_release_year > Date.today.year
  end
end
