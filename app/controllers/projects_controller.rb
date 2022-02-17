class ProjectsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :redirect_if_not_authorised, except: [:index, :new, :create]

  def index
    @projects = []
    Project.where(:organization_id => params[:id]).each do |project|
      @projects.push(Project.find(project.id))
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.organization_id = params[:id]

    if @project.save
      redirect_to "/organization/#{params[:id]}/projects"
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def generate_schedule
    @project = Project.find(params[:id])
    @schedule = view_context.get_schedule(@project)

    @schedule.each do |record|
      ScheduleTask.create(
        project_id: @project.id,
        start_date: record[0],
        end_date: record[0] + Task.find(record[3]).average_duration,
        human_resource_id: record[1],
        human_resource_instance_id: record[2],
        task_id: record[3],
        task_instance_id: record[4]
      )
    end

    redirect_to "/projects/#{params[:id]}"
  end

  def view_schedule
    @schedules = ScheduleTask.where(:project_id => params[:id]).order(:start_date)
  end

  def delete_schedule
    @project = Project.find(params[:id])
  end

  def destroy_schedule
    schedules = ScheduleTask.where(:project_id => params[:id])
    error_found = false

    schedules.each do |schedule|
      schedule.destroy
    end

    redirect_to "/projects/#{params[:id]}"
  end

  def delete
    @project = Project.find(params[:id])
  end

  def destroy
    project = Project.find(params[:id])

    if project.destroy
      redirect_to "/organization/#{params[:id]}/projects"
    else
      render "delete"
    end
  end

  private
    def redirect_if_not_authorised
      unless OrganizationUser.exists?(:user_id => current_user.id, :organization_id => Project.find(params[:id]).organization_id)
        redirect_to '/home'
      end
    end

    def project_params
      params.require(:project).permit(:name)
    end
end
