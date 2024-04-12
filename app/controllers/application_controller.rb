class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :first_name, :last_name, :dob, :address, :phone, :gender, :role])
    devise_parameter_sanitizer.permit(:invite, keys: [:email, :first_name, :last_name, :role])

  end

end
