class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artist
  before_action :set_song, only: [:edit, :update, :destroy]

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

  def edit
  end

  def update
    title = song_params[:title]
    album_name = song_params[:album_name]
    genre = song_params[:genre]
    song_id = @song.id
    sql = "UPDATE songs SET title = '#{title}', album_name = '#{album_name}', genre = '#{genre}',updated_at = '#{Time.now}' WHERE id = #{song_id}"
  
    ActiveRecord::Base.connection.execute(sql)
    redirect_to artist_path(@artist.id), notice: "Songs updated successfully!"
  end

  def show
    @artist
  end

  def destroy
    sql = "DELETE FROM songs WHERE id = #{@song.id}"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to artist_path(@artist.id), notice: "Songs deleted succrssfully"
  end


  private

  def set_artist
    @artist = Artist.find(params[:artist_id])
  end

  def set_song
    @song = @artist.songs.find(params[:id])
  end
  
  def song_params
    params.require(:song).permit(:title, :album_name, :genre)
  end
end
