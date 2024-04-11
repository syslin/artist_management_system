class SongsController < ApplicationController
  before_action :set_artist

  # def index
  #   sql = "Select * from Songs"
  #   @songs = ActiveRecord::Base.connection.execute(sql)
  # end

  def new
    @song = @artist.songs.build
  end

  def create
    title = song_params[:title]
    artist_id = @artist.id
    album_name = song_params[:album_name]
    genre = song_params[:genre]
    sql = "INSERT INTO songs (title, artist_id, album_name, genre, created_at, updated_at) VALUES('#{title}','#{artist_id}', '#{album_name}', '#{genre}', '#{Time.now}', '#{Time.now}')"

    ActiveRecord::Base.connection.execute(sql)

    redirect_to artists_path, notice: 'Registered successfully!'
  end

  private

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end
  
  def song_params
    params.require(:song).permit(:title, :album_name, :genre)
  end
end
