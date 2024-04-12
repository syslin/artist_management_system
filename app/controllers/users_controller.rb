class UsersController < ApplicationController
  before_action :authenticate_user!


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



  private

  def user_params
    params.permit(:first_name, :last_name, :phone, :dob, :address, :gender, :role, :email, :password, :password_confirmation)
  end
end
