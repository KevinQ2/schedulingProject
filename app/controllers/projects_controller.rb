class ProjectsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member

  def index
    @projects = Project.where(:organization_id => session[:organization_id])
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.organization_id = session[:organization_id]

    if @project.save
      redirect_to projects_path
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def delete
    @project = Project.find(params[:id])
  end

  def destroy
    project = Project.find(params[:id])
    organization_id = project.organization_id

    if project.destroy
      redirect_to projects_path
    else
      render "delete"
    end
  end

  def generate_schedule
    @project = Project.find(params[:id])
    schedule = view_context.get_schedule(@project)

    schedule.each do |record|
      ScheduleTask.create(
        project_id: @project.id,
        start_date: record[1][0] - TaskResource.find(record[1][1]).duration,
        end_date: record[1][0],
        task_resource_id: record[1][1]
      )
    end

    redirect_to "show"
  end

  def view_schedule
    @schedules = ScheduleTask.where(:project_id => params[:id]).order(:start_date)
  end

  def delete_schedule
    @project = Project.find(params[:id])
  end

  def destroy_schedule
    schedules = ScheduleTask.where(:project_id => params[:id])

    schedules.each do |schedule|
      schedule.destroy
    end

    redirect_to project_path(session[:project_id])
  end

  private
    def redirect_if_not_authorised
      unless OrganizationUser.exists?(:user_id => current_user.id, :organization_id => Project.find(params[:id]).organization_id)
        redirect_to '/home'
      end
    end

    def set_session
      session[:project_id] = params[:id]
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def project_params
      params.require(:project).permit(:name)
    end
end
