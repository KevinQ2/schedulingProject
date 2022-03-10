class ProjectsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member

  def show
    @project = Project.find(params[:id])
    @capacity_conflicts = helpers.get_capacity_conflicts(@project.id)
    @cycle_conflicts = helpers.get_cycles(@project.id)
    @unallocated_conflicts = helpers.get_unallocated_conflicts(@project.id)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.organization_id = session[:organization_id]

    if @project.save
      redirect_to organization_path(session[:organization_id])
    else
      render "new"
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    @project.attributes = project_params

    if @project.save
      redirect_to organization_path(session[:organization_id])
    else
      render "edit"
    end
  end

  def delete
    @project = Project.find(params[:id])
  end

  def destroy
    project = Project.find(params[:id])
    organization_id = project.organization_id

    if project.destroy
      redirect_to organization_path(session[:organization_id])
    else
      render "delete"
    end
  end

  def generate_schedule
    @project = Project.find(params[:id])
    @capacity_conflicts = helpers.get_capacity_conflicts(@project.id)
    @cycle_conflicts = helpers.get_cycles(@project.id)
    @unallocated_conflicts = helpers.get_unallocated_conflicts(@project.id)

    if @capacity_conflicts.count == 0 and @cycle_conflicts.count == 0 and @unallocated_conflicts.count == 0
      schedule = helpers.generate_schedule(@project, params[:scheme], params[:priority_rule])

      schedule.each do |record|
        ScheduleTask.create(
          project_id: @project.id,
          start_date: record[1][0] - TaskResource.find(record[1][1]).duration,
          end_date: record[1][0],
          task_resource_id: record[1][1]
        )
      end
    end

    render "show"
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
