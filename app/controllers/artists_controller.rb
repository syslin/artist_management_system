class ArtistsController < ApplicationController

  def index
    sql = "Select * from Artists"
    @artists = ActiveRecord::Base.connection.execute(sql)
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

  private

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
