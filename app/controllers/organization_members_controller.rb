class OrganizationMembersController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member
  before_action :redirect_if_not_host, only: [:edit, :update, :delete, :destroy]
  before_action :redirect_if_not_invite, only: [:new, :create]

  def index
    @organization_member = OrganizationMember.where(:organization_id => session[:organization_id])
  end

  def new
    @organization_member = OrganizationMember.new
    if params[:type] != nil
      session[:organization_member_type] = params[:type]
    elsif session[:organization_member_type] == nil
      session[:organization_member_type] = "Username"
    end
  end

  def create
    @organization_member = OrganizationMember.new(organization_id: session[:organization_id])

    if helpers.is_host_member?(session[:organization_id])
      @organization_member.can_edit = params[:can_edit]
      @organization_member.can_invite = params[:can_invite]
    end

    user = nil
    type = params[:type]

    if type == "Telephone"
      user = User.find_by(:telephone => params[:telephone])
    elsif type == "Email"
      user = User.find_by(:email => params[:email])
    else
      user = User.find_by(:username => params[:username])
    end

    if user == nil
      flash.alert = "Person with this " + type.downcase + " is not registered in the system"
      render "new"
    else
      @organization_member.user_id = user.id

      if @organization_member.save
        redirect_to organization_members_path
      else
        render "new"
      end
    end
  end

  def edit
    @organization_member = OrganizationMember.find(params[:id])
  end

  def update
    @organization_member = OrganizationMember.find(params[:id])
    @organization_member.attributes = organization_member_params

    if @organization_member.save
      redirect_to organization_members_path
    else
      render "edit"
    end
  end

  def delete
    @organization_member = OrganizationMember.find(params[:id])
  end

  def destroy
    organization_member = OrganizationMember.find(params[:id])
    if organization_member.destroy
      redirect_to organization_members_path
    else
      render "delete"
    end
  end

  private
    def set_session
      session[:organization_id] = OrganizationMember.find(params[:id]).organization_id
    end

    def organization_member_params
      params.require(:organization_member).permit(:can_edit, :can_invite)
    end
end
