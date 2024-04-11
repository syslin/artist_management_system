class User < ApplicationRecord

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates_format_of :dob, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "^Date must be in the following format: mm/dd/yyyy"

  
  enum gender: [ :Male, :Female, :Other ]
  enum role: [:Super_admin, :Artist_manager, :Artist]
end
