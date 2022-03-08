class SessionsController < ApplicationController
  def new
    @user = User.new()
  end

  def create
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:username] = @user.username
      redirect_to '/home'
    else
      redirect_to '/login'
    end
  end

  def destroy
    session.delete(:username)
    redirect_to(root_url)
  end

  private
    def login_params
      params.require(:user).permit(:username, :password)
    end
end
