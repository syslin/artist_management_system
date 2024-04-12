class CreateArtists < ActiveRecord::Migration[7.1]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.datetime :dob
      t.integer :gender, default: 0
      t.string :address
      t.integer :first_release_year
      t.integer :no_of_albums_released
      t.timestamps
    end
  end
end
