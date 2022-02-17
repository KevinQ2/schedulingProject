class TasksController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :redirect_if_not_authorised, except: [:index, :new, :create]

  def index
    @tasks = Task.where(:project_id => params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.project_id = params[:id]

    if @task.save
      redirect_to "/project/#{params[:id]}/tasks"
    else
      render "new"
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def delete
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to "/project/#{params[:id]}/tasks"
  end

  private
    def redirect_if_not_authorised
      unless OrganizationUser.exists?(:user_id => current_user.id, :organization_id => Task.find(params[:id]).project.organization_id)
        redirect_to '/home'
      end
    end

    def task_params
      params.require(:task).permit(:title, :description, :average_duration, :instances)
    end
end
