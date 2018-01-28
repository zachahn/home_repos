class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||=
      if session[:user_id]
        User.find(session[:user_id])
      else
        Guest.new
      end
  end

  def logged_in?
    !!session[:user_id]
  end
end
