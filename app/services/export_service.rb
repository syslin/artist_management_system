require 'csv'
class ExportService

  def self.to_csv
    attributes = %w[id name dob gender address first_release_year no_of_albums_released]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      ActiveRecord::Base.connection.execute("SELECT #{attributes.join(', ')} FROM artists").each do |row|
        csv << row.values
      end
    end
  end
end