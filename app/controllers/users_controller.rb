class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy, :show]

  def index
    sql = "Select * from Users;"
    @users = ActiveRecord::Base.connection.execute(sql)
  end

  def new
  end

  def create
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

  def edit
  end

  def update
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

  def show
    @user
  end

  def destroy
    sql = "DELETE FROM users WHERE id = #{@user.id}"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to authenticated_root_path, notice: "User deleted succrssfully"
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :dob, :address, :gender, :role, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
