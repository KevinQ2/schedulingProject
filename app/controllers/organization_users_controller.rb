class OrganizationUsersController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :update_new, :create]
  before_action :redirect_if_not_member

  def index
    @organization_user = OrganizationUser.where(:organization_id => session[:organization_id])
  end

  def new
    @organization_user = OrganizationUser.new
    if session[:organization_user_type] == nil
      session[:organization_user_type] = "Username"
    end
  end

  def update_new
    @organization_user = OrganizationUser.new
    session[:organization_user_type] = params[:type]
    render "new"
  end

  def create
    @organization_user = OrganizationUser.new(:organization_id => session[:organization_id], :can_edit => params[:can_edit])

    @user = nil
    type = params[:type]

    if type == "Telephone"
      @user = User.find_by(:telephone => params[:telephone])
    elsif type == "Email"
      @user = User.find_by(:email => params[:email])
    else
      @user = User.find_by(:username => params[:username])
    end

    if @user == nil
      flash.alert = "Person with this " + type.downcase + " is not registered in the system"
      render "new"
    else
      @organization_user.user_id = @user.id

      if @organization_user.save
        redirect_to organization_users_path
      else
        render "new"
      end
    end
  end

  def edit
    @organization_user = OrganizationUser.find(params[:id])
  end

  def update
    @organization_user = OrganizationUser.find(params[:id])
    @organization_user.attributes = organization_user_params

    if @organization_user.save
      redirect_to organization_users_path
    else
      render "edit"
    end
  end

  def delete
    @organization_user = OrganizationUser.find(params[:id])
  end

  def destroy
    organization_user = OrganizationUser.find(params[:id])
    if organization_user.destroy
      redirect_to organization_users_path
    else
      render "delete"
    end
  end

  private
    def set_session
      session[:organization_id] = OrganizationUser.find(params[:id]).organization_id
    end

    def organization_user_params
      params.require(:organization_user).permit(:can_edit)
    end
end
