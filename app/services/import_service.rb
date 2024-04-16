require 'csv'
class ImportService
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

        ActiveRecord::Base.connection.execute("INSERT INTO artists (name, dob, gender, address, first_release_year, no_of_albums_released, created_at, updated_at) VALUES ('#{name}', #{parsed_date ? "'#{parsed_date}'" : 'NULL'}, '#{gender}', '#{address}', '#{first_release_year}', '#{no_of_albums_released}' , '#{Time.now}', '#{Time.now}')")
      rescue => e
        puts "Error processing row: #{e.message}"
      end
    end
  end
end