class Artist < ApplicationRecord

  has_many :songs, dependent: :destroy
  validates_format_of :dob, :with => /\d{2}\/\d{2}\/\d{4}/, :message => "^Date must be in the following format: mm/dd/yyyy"
  
  enum gender: [ :Male, :Female, :Other ]
  
  require 'csv'
  require 'date'


  def self.to_csv
    attributes = %w[id name dob gender address first_release_year no_of_albums_released]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      connection.execute("SELECT #{attributes.join(', ')} FROM artists").each do |row|
        csv << row.values
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        if row.blank? || row.to_s.strip.empty?
          puts "Skipping empty row"
          next
        end
  
        puts "Processing row: #{row}"
        date = row['dob']
        parsed_date = date.present? ? Date.parse(date).strftime("%m/%d/%Y") : nil

        name = row['name']
        gender = case row['gender']
                  when 'Male' then 0
                  when 'Female' then 1
                  else 3 # Default value or handle other cases as needed
                  end
        address = row['address'] 
        first_release_year = row['first_release_year'].to_i 
        no_of_albums_released = row['no_of_album_released'].to_i 

        connection.execute("INSERT INTO artists (name, dob, gender, address, first_release_year, no_of_albums_released, created_at, updated_at) VALUES ('#{name}', #{parsed_date ? "'#{parsed_date}'" : 'NULL'}, '#{gender}', '#{address}', '#{first_release_year}', '#{no_of_albums_released}' , '#{Time.now}', '#{Time.now}')")
      rescue => e
        puts "Error processing row: #{e.message}"
      end
    end
  end
end
