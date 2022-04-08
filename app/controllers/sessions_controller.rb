class SessionsController < ApplicationController
  def new
    @user = User.new()
  end

  def create
    # authenticate user's login details
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:username] = @user.username
      redirect_to "/home"
    else
      flash.alert = "Login details are incorrect"
      render "new"
    end
  end

  def destroy
    # log out
    session.delete(:username)
    redirect_to(root_url)
  end

  private
    def login_params
      params.require(:user).permit(:username, :password)
    end
end
