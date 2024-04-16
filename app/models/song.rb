class Song < ApplicationRecord

  belongs_to :artist 

  validates :title, presence: true
  
  enum genre: [ :rnb, :country, :classic, :rock, :jazz ]
   
end
