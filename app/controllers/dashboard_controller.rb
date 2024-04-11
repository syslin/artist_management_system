class DashboardController < ApplicationController

  def home
    sql = "Select * from Users;"
    @users = ActiveRecord::Base.connection.execute(sql)
  end
end
