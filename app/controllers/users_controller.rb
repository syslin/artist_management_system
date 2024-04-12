class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy, :show]
  before_action :find_current_user_role


  def index
    check_user_role([1,0, 2])  # Artist manager role & superadmin & artist
    @users = fetch_users if authorized?
  end

  def new
    check_user_role([0])
    @song = @artist.songs.build if authorized?
  end

  def create
    check_user_role([0])
    if authorized?
      first_name = user_params[:first_name]
      last_name = user_params[:last_name]
      phone = user_params[:phone]
      dob = user_params[:dob]
      address = user_params[:address]
      gender = user_params[:gender]
      email = user_params[:email]
      password = user_params[:password]
      password_confirmation = user_params[:password_confirmation]
      role = user_params[:role]
      password_digest = BCrypt::Password.create('password')
      sql = "INSERT INTO users (first_name, last_name, email, password_digest, phone, dob, gender, address, role, created_at, updated_at) VALUES('#{first_name}', '#{last_name}', '#{email}', '#{password_digest}', '#{phone}', '#{dob}', '#{gender}', '#{address}', '#{role}', '#{Time.now}', '#{Time.now}')"

      ActiveRecord::Base.connection.execute(sql)

      redirect_to root_path, notice: 'Registered successfully!'
    end
  end

  def edit
    check_user_role([0]) #Super Admin
    redirect_back fallback_location: authenticated_root_path, alert: 'You do not have permission to access this page.' unless authorized?
  end

  def update
    check_user_role([0])
    if authorized?
      first_name = user_params[:first_name] 
      last_name = user_params[:last_name]
      phone = user_params[:phone]
      dob = user_params[:dob]
      gender = user_params[:gender]
      address = user_params[:address]
      role = user_params[:role]
    
      sql = "UPDATE users SET first_name = '#{first_name}',last_name = '#{last_name}', phone = '#{phone}', dob = '#{dob}', gender = '#{gender}', address = '#{address}', role = '#{role}', updated_at = '#{Time.now}' WHERE id = #{@user.id}"
    
      ActiveRecord::Base.connection.execute(sql)
      redirect_to @user, notice: 'User updated successfully!'
    end
  end

  def show
    check_user_role([0]) 
    @song if authorized? 
  end

  def destroy
    check_user_role([0]) 
    if authorized?
      sql = "DELETE FROM users WHERE id = #{@user.id}"
      ActiveRecord::Base.connection.execute(sql)
      redirect_to authenticated_root_path, notice: "User deleted succrssfully"
    end
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :dob, :address, :gender, :role, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
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

  def fetch_users
    sql = "Select * from Users;"
    @users = ActiveRecord::Base.connection.execute(sql)
  end
end
