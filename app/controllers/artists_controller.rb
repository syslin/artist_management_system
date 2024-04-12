class ArtistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artist, only: [:edit, :show, :destroy, :update]
  before_action :find_current_user_role

  def index
    check_user_role([1,0, 2])  # Artist manager role & superadmin & artist
    @artists = fetch_artists if authorized?
  end

  def new
    check_user_role([1]) # Artist manager role
    @artist = Artist.new if authorized?
  end

  def create
    check_user_role([1]) # Artist manager role
    if authorized?
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
  end

  def edit
    check_user_role([1]) # Artist manager role
    redirect_back fallback_location: authenticated_root_path, alert: 'You do not have permission to access this page.' unless authorized?
  end

  def update
    check_user_role([1]) # Artist manager role
    if authorized?
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
  end

  def show
    check_user_role([1,0, 2]) # Artist manager, Superadmin, Artist
    @artist if authorized?
  end

  def destroy
    check_user_role([1]) # Artist manager role
    if authorized?
      sql = "DELETE FROM songs WHERE artist_id = #{@artist.id}"
      ActiveRecord::Base.connection.execute(sql)
      sql = "DELETE FROM artists WHERE id = #{@artist.id}"
      ActiveRecord::Base.connection.execute(sql)
      redirect_to authenticated_root_path, notice: "Artist deleted succrssfully"
    end
  end


  def import
    check_user_role([1]) # Artist manager role
    if authorized?
      Artist.import(params[:file])
      redirect_to artists_path, notice: "CSV imported successfully!"
    end
  end

  def export
    check_user_role([1]) # Artist manager role
    if authorized?
      respond_to do |format|
        format.csv { send_data Artist.to_csv, filename: "artists-#{Date.today}.csv" }
      end
    end
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
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

  def fetch_artists
    sql = "SELECT * FROM artists"
    ActiveRecord::Base.connection.execute(sql)
  end
end
