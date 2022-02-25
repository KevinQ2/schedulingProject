class UsersController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:new, :create]

  def index

  end

  def show
  end

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if logged_in?
        redirect_to '/users/index'
      else
        redirect_to '/login'
      end
    end
  end

  def delete
    
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :first_name, :last_name, :email, :telephone)
    end
end
