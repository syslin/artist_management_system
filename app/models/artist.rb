class Artist < ApplicationRecord

  has_many :songs, dependent: :destroy
  validates_format_of :dob, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "^Date must be in the following format: mm/dd/yyyy"
  
  enum gender: [ :Male, :Female, :Other ]

end
