class HumanResourcesController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member

  def index
    @human_resources = HumanResource.where(:project => session[:project_id])
  end

  def new
    @human_resource = HumanResource.new
  end

  def create
    @human_resource = HumanResource.new(human_resource_params)
    @human_resource.project_id = session[:project_id]

    if @human_resource.save
      redirect_to human_resources_path
    else
      render "new"
    end
  end

  def edit
    @human_resource = HumanResource.find(params[:id])
  end

  def update
    @human_resource = HumanResource.find(params[:id])
    @human_resource.attributes = human_resource_params

    if @human_resource.save
      redirect_to human_resources_path
    else
      render "edit"
    end
  end

  def delete
    @human_resource = HumanResource.find(params[:id])
  end

  def destroy
    human_resource = HumanResource.find(params[:id])
    project_id = human_resource.project_id

    human_resource.destroy
    redirect_to human_resources_path
  end

  private
    def set_session
      session[:project_id] = HumanResource.find(params[:id]).project_id
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def human_resource_params
      params.require(:human_resource).permit(:name, :instances)
    end
end
