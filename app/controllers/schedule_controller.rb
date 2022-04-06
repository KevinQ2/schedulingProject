class ScheduleController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session
  before_action :redirect_if_not_member
  before_action :redirect_if_not_edit, except: [:show]

  def show
    @schedules = ScheduleAllocation.where(:project_id => params[:id]).order(:start_date)
  end

  def delete
    @project = Project.find(params[:id])
  end

  def destroy
    schedules = ScheduleAllocation.where(:project_id => params[:id])

    schedules.each do |schedule|
      schedule.destroy
    end

    redirect_to project_path(session[:project_id])
  end

  private
    def set_session
      session[:project_id] = params[:id]
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

end
