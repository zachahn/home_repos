class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?
  helper_method :current_user

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
