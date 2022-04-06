class OrganizationsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create, :member_reply]
  before_action :redirect_if_not_member, except: [:index, :new, :create, :member_reply]
  before_action :redirect_if_not_host, except: [:index, :new, :create, :show, :member_reply]

  def index
    @organizations = []

    OrganizationMember.where(:user_id => current_user.id).each do |organization_member|
      @organizations.push(Organization.find(organization_member.organization_id))
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      OrganizationMember.create(
        organization_id: @organization.id,
        user_id: current_user.id,
        is_host: true,
        pending: false
      )
      redirect_to organizations_path
    else
      render "new"
    end
  end

  def show
    @organization = Organization.find(params[:id])
    @projects = Project.where(:organization_id => params[:id])
    @users = OrganizationMember.where(:organization_id => params[:id])
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

  def member_reply
    organization = Organization.find(params[:id])
    organization_member = OrganizationMember.find_by(
      organization_id: organization.id,
      user_id: current_user.id
    )

    if params[:submit] == "accept"
      organization_member.pending = false
      organization_member.save
    else
      organization_member.destroy
    end

    redirect_to organizations_path
  end

  private
    def set_session
      session[:organization_id] = params[:id]
    end

    def organization_params
      params.require(:organization).permit(:name)
    end
end
