class UsersController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:new, :create]

  def show
    @user = current_user
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = user_edit_params

    if @user.save
      redirect_to user_path(@user.id)
    else
      render "edit"
    end
  end

  def change_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    @user.attributes = user_password_params

    if @user.save
      redirect_to user_path(@user.id)
    else
      render "change_password"
    end
  end

  def delete
    @user = current_user
  end

  def destroy
    @user = current_user
    @user.destroy

    redirect_to '/login'
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :first_name, :last_name, :email, :telephone)
    end

    def user_edit_params
      params.require(:user).permit(:username, :first_name, :last_name, :email, :telephone)
    end

    def user_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
