class UsersController < ApplicationController
  before_action :redirect_if_not_logged_in, except: [:new, :create]

  def index
    @users = []
    OrganizationUser.where(:organization_id => params[:id]).each do |organization_user|
      @users.push(User.find(organization_user.user_id))
    end
  end

  def show
    @organization_user = OrganizationUser.find(params[:id])
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
    @organization_user = OrganizationUser.find(params[:id])
    
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :first_name, :last_name, :email, :telephone)
    end
end
