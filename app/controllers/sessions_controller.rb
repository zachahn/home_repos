class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email]) || Guest.new

    if user.authenticate(params[:password])
      session[:user_id] = user.id
    end
  end

  def destroy
    session[:user_id] = nil
  end
end
