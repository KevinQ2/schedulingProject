class TasksController < ApplicationController
  before_action :redirect_if_not_logged_in

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

  private
    def task_params
      params.require(:task).permit(:title, :description, :average_duration, :amount)
    end
end
