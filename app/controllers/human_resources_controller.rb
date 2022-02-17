class HumanResourcesController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :redirect_if_not_authorised, except: [:index, :new, :create]

  def index
    @human_resources = HumanResource.where(:project => params[:id])
  end

  def show
    @human_resource = HumanResource.find(params[:id])
  end

  def new
    @human_resource = HumanResource.new
  end

  def create
    @human_resource = HumanResource.new(human_resource_params)
    @human_resource.project_id = params[:id]

    if @human_resource.save
      redirect_to human_resources_path
    else
      render "new"
    end
  end

  def edit
    @human_resource = HumanResource.find(params[:id])
  end

  def delete
    @human_resource = HumanResource.find(params[:id])
  end

  def destroy
    human_resource = HumanResource.find(params[:id])

    if human_resource.destroy
      redirect_to "/project/#{params[:id]}/human_resources"
    else
      render "delete"
    end
  end

  private
    def redirect_if_not_authorised
      unless OrganizationUser.exists?(:user_id => current_user.id, :organization_id => Task.find(params[:id]).project.organization_id)
        redirect_to '/home'
      end
    end

    def human_resource_params
      params.require(:human_resource).permit(:name, :instances)
    end
end
