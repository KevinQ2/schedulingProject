class TaskResourcesController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member

  def index
    @task_resources = []
    TaskResource.where(:task_id => session[:task_id]).each do |task_resource|
      @task_resources.push(TaskResource.find(task_resource.id))
    end
  end

  def show
    @task_resource = TaskResource.find(params[:id])
  end

  def new
    @task_resource = TaskResource.new
  end

  def create
    @task_resource = TaskResource.new(task_resource_params)

    if @task_resource.save
      redirect_to task_resources_path
    end
  end

  def edit
    @task_resource = TaskResource.find(params[:id])
  end

  def delete
    @task_resource = TaskResource.find(params[:id])
  end

  def destroy
    task_resource = TaskResource.find(params[:id])
    project_id = task_resource.project_id

    task_resource.destroy
    redirect_to task_resources_path
  end

  private
    def set_session
      session[:project_id] = TaskResource.find(params[:id]).project_id
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def task_resource_params
      params.require(:task_resource).permit(:task_id, :human_resource_id, :duration, :capacity)
    end
end
