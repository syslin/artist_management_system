class Song < ApplicationRecord

  belongs_to :artist 

  enum genre: [ :rnb, :country, :classic, :rock, :jazz ]

end
