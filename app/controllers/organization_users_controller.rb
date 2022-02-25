class OrganizationUsersController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member

  def index
    @organization_user = OrganizationUser.where(:organization_id => session[:organization_id])
  end

  def show
    @organization_user = OrganizationUser.find(params[:id])
  end

  def new
    @organization_user = OrganizationUser.new
  end

  def create
    @organization_user = OrganizationUser.new(organization_params)

    if @organization_user.save
      OrganizationUser.create(:organization_id => session[:organization_id])
      redirect_to organization_users_path
    else
      render "new"
    end
  end

  def edit
    @organization_user = OrganizationUser.find(params[:id])
  end

  def update
    @organization_user = OrganizationUser.find(params[:id])
    @organization_user.attributes = organization_params

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
    
    #def organization_user_params
    #  params.require(:organization_user).permit(:)
    #end
end
