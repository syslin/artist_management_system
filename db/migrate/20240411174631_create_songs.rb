class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.string :album_name
      t.integer :genre, default: 0
      t.references :artist, null: false, foreign_key: true
      t.timestamps
    end
  end
end
