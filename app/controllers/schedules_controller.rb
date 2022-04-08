class SchedulesController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:create]
  before_action :redirect_if_not_member
  before_action :redirect_if_not_edit, except: [:show]

  def create
    project = Project.find(session[:project_id])

    if !helpers.has_conflicts?(project)
      # compute schedule
      if params[:submit] == "priority rule"
        schedule = helpers.generate_schedule(project, params[:scheme], params[:priority_rule], params[:sampling], params[:bias])
      elsif params[:submit] == "algorithm"
        if params[:algorithm] = "Genetic algorithm"
          schedule = helpers.generate_genetic_schedule(project)
          messages = schedule[0][1].clone
          schedule[0] = schedule[0][0]
        end
      end

      # store schedule
      schedule[0].each do |record|
        ScheduleAllocation.create(
          project_id: project.id,
          start_date: record[1][0] - PotentialAllocation.find(record[1][1]).duration,
          end_date: record[1][0],
          potential_allocation_id: record[1][1]
        )
      end
    end

    redirect_to project_path(session[:project_id])
  end

  def show
    @schedules = ScheduleAllocation.where(:project_id => params[:id]).order(:start_date)
  end

  def delete
    @project = Project.find(params[:id])
  end

  def destroy
    # clear all schedule records
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
