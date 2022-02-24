class TaskResourcesController < ApplicationController
  before_action :redirect_if_not_logged_in

  def index
    @task_resources = []
    TaskResource.where(:task_id => params[:id]).each do |task_resource|
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
      redirect_to "/task/#{params[:id]}/task_resources"
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
    redirect_to "/project/#{project_id}/task_resources"
  end

  private
    def redirect_if_not_authorised
      unless OrganizationUser.exists?(:user_id => current_user.id, :organization_id => TaskResource.find(params[:id]).task.project.organization_id)
        redirect_to '/home'
      end
    end

    def task_resource_params
      params.require(:task_resource).permit(:task_id, :human_resource_id, :duration, :capacity)
    end
end
