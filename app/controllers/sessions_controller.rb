class SessionsController < ApplicationController
  def new
    @login = Login.new
  end

  def create
    @login = Login.new(login_params.to_h.symbolize_keys)

    if @login.authenticate?
      session[:user_id] = @login.user.id

      flash[:notice] = "Logged in as #{@login.email}"
      redirect_to root_path
    else
      flash[:alert] = "Incorrect username or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out"

    redirect_to root_path
  end

  private

  def login_params
    params.require(:login).permit(:email, :password)
  end
end
