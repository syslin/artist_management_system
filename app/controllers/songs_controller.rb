class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artist
  before_action :set_song, only: [:edit, :update, :destroy]
  before_action :find_current_user_role

  def new
    check_user_role([2])
    @song = @artist.songs.build if authorized?
  end

  def create
    check_user_role([2])
    if authorized?
      title = song_params[:title]
      artist_id = @artist.id
      album_name = song_params[:album_name]
      genre = song_params[:genre]
      sql = "INSERT INTO songs (title, artist_id, album_name, genre, created_at, updated_at) VALUES('#{title}','#{artist_id}', '#{album_name}', '#{genre}', '#{Time.now}', '#{Time.now}')"

      ActiveRecord::Base.connection.execute(sql)

      redirect_to artist_path(artist_id), notice: 'Registered successfully!'
    end
  end

  def edit
    check_user_role([2]) # Artist manager role
    redirect_back fallback_location: authenticated_root_path, alert: 'You do not have permission to access this page.' unless authorized?
  end

  def update
    check_user_role([2])
    if authorized?
      title = song_params[:title]
      album_name = song_params[:album_name]
      genre = song_params[:genre]
      song_id = @song.id
      sql = "UPDATE songs SET title = '#{title}', album_name = '#{album_name}', genre = '#{genre}',updated_at = '#{Time.now}' WHERE id = #{song_id}"
    
      ActiveRecord::Base.connection.execute(sql)
      redirect_to artist_path(@artist.id), notice: "Songs updated successfully!"
    end
  end

  def show
    check_user_role([1,0, 2]) # Artist manager, superadmin, artist
    @song if authorized?
  end

  def destroy
    check_user_role([2]) # Artist 
    if authorized?
      sql = "DELETE FROM songs WHERE id = #{@song.id}"
      ActiveRecord::Base.connection.execute(sql)
      redirect_to artist_path(@artist.id), notice: "Songs deleted succrssfully"
    end
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

  def find_current_user_role
    sql = "SELECT role FROM users WHERE id = #{current_user.id}"
    @user_role = ActiveRecord::Base.connection.execute(sql).pluck('role')
  end

  def check_user_role(expected_roles)
    if @user_role.present? && (@user_role & expected_roles).any?
      true
    else
      redirect_back fallback_location: authenticated_root_path, alert: 'You do not have permission to access this page.'
      false
    end
  end

  def authorized?
    @user_role.present?
  end
end
