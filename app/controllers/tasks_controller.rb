class TasksController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member
  before_action :redirect_if_not_edit, except: [:index]

  def index
    @tasks = Task.where(:project_id => session[:project_id])
    @can_edit = helpers.is_edit_member?(session[:organization_id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.project_id = session[:project_id]

    if @task.save
      # changes to project environment outdates the schedule
      helpers.clear_schedule(@task.project_id)
      redirect_to tasks_path
    else
      render "new"
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.attributes = task_params

    if @task.save
      # changes to project environment outdates the schedule
      helpers.clear_schedule(@task.project_id)
      redirect_to tasks_path
    else
      render "edit"
    end
  end

  def edit_precedences
    @task = Task.find(params[:id])
    @tasks = Task.where(:project_id => session[:project_id])
    @tasks = @tasks.where.not(:id => @task.id)
    @precedences = TaskPrecedence.where(:task_id => @task.id)
  end

  def update_precedences
    failed_delete = []
    failed_create = []

    @task = Task.find(params[:id])
    @tasks = Task.where(:project_id => session[:project_id])
    @tasks = @tasks.where.not(:id => @task.id)
    @precedences = TaskPrecedence.where(:task_id => params[:id])

    # changes to project environment outdates the schedule
    helpers.clear_schedule(@task.project_id)

    # delete all then precedences then repopulate
    @precedences.each do |precedence|
      if !precedence.destroy
        failed_delete.push(precedence)
      end
    end

    params[:precedences].each do |precedence|
      if precedence != ""
        if !TaskPrecedence.create(:task_id => params[:id], :required_task_id => precedence)
          failed_create.push(precedence)
        end
      end
    end

    if (failed_create - failed_delete | failed_delete - failed_create).count == 0
      flash.alert = "Successfully updated precedences"
    else
      creates = failed_create - failed_delete
      deletes = failed_delete - failed_create

      if creates.count > 0
        flash.alert = "Failed to create precedences " + creates.to_s
      end
      if deletes.count > 0
        flash.alert = "Failed to delete precedences " + deletes.to_s
      end
    end

    redirect_to tasks_path
  end

  def delete
    @task = Task.find(params[:id])
  end

  def destroy
    # changes to project environment outdates the schedule
    @task = Task.find(params[:id])
    @task.destroy
    helpers.clear_schedule(@task.project_id)
    redirect_to tasks_path
  end

  private
    def set_session
      session[:project_id] = Task.find(params[:id]).project_id
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def task_params
      params.require(:task).permit(:title, :description)
    end
end
