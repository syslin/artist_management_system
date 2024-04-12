class ArtistsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_artist, only: [:edit, :show, :destroy, :update]


  def index
      @artists = [] 
      sql = "SELECT * FROM artists"
      @artists = ActiveRecord::Base.connection.execute(sql)
    rescue => e
      flash[:alert] = "An error occurred while fetching artists: #{e.message}"
  end

  def new
    @artist = Artist.new
  end

  def create
    name = artist_params[:name]
    dob = artist_params[:dob]
    gender = artist_params[:gender]
    address = artist_params[:address]
    first_release_year = artist_params[:first_release_year]
    no_of_albums_released = artist_params[:no_of_albums_released]
    sql = "INSERT INTO artists (name, dob, gender, address, first_release_year, no_of_albums_released, created_at, updated_at) VALUES('#{name}','#{dob}', '#{gender}', '#{address}', '#{first_release_year.to_i}', '#{no_of_albums_released.to_i}', '#{Time.now}', '#{Time.now}')"

    ActiveRecord::Base.connection.execute(sql)

    redirect_to artists_path, notice: 'Registered successfully!'
  end

  def edit
  end

  def update
    name = artist_params[:name]
    dob = artist_params[:dob]
    gender = artist_params[:gender]
    address = artist_params[:address]
    first_release_year = artist_params[:first_release_year]
    no_of_albums_released = artist_params[:no_of_albums_released]
  
    sql = "UPDATE artists SET name = '#{name}', dob = '#{dob}', gender = '#{gender}', address = '#{address}', first_release_year = '#{first_release_year}', no_of_albums_released = '#{no_of_albums_released}', updated_at = '#{Time.now}' WHERE id = #{@artist.id}"
  
    ActiveRecord::Base.connection.execute(sql)
    redirect_to @artist, notice: 'Artist updated successfully!'
  end

  def show
    @artist
  end

  def destroy
    sql = "DELETE FROM songs WHERE artist_id = #{@artist.id}"
    ActiveRecord::Base.connection.execute(sql)
    sql = "DELETE FROM artists WHERE id = #{@artist.id}"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to authenticated_root_path, notice: "Artist deleted succrssfully"
  end


  def import
    Artist.import(params[:file])
    redirect_to artists_path, notice: "CSV imported successfully!"
  end

  def export
    respond_to do |format|
      format.csv { send_data Artist.to_csv, filename: "artists-#{Date.today}.csv" }
    end
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
