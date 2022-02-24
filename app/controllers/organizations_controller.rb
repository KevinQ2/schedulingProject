class OrganizationsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :redirect_if_not_authorised, except: [:index, :new, :create]

  def index
    @organizations = []

    OrganizationUser.all.each do |organization|
      if organization.user_id == current_user.id
        if Organization.exists?(id: organization.organization_id)
          @organizations.push(Organization.find(organization.organization_id))
        end
      end
    end
  end

  def show
    @organization = Organization.find(params[:id])
    @projects = Project.where(:organization_id => params[:id])
    @users = OrganizationUser.where(:organization_id => params[:id])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      OrganizationUser.create(:organization_id => @organization.id, :user_id => current_user.id)
      redirect_to organizations_path
    else
      render new
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])
    @organization.attributes = organization_params

    if @organization.save
      redirect_to organizations_path
    else
      render "edit"
    end
  end

  def delete
    @organization = Organization.find(params[:id])
  end

  def destroy
    organization = Organization.find(params[:id])
    organization.destroy
    redirect_to organizations_path
  end

  private
    def redirect_if_not_authorised
      unless OrganizationUser.exists?(:user_id => current_user.id, :organization_id => params[:id])
        redirect_to '/home'
      end
    end

    def organization_params
      params.require(:organization).permit(:name)
    end
end
