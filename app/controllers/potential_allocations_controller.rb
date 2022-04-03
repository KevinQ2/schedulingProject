class PotentialAllocationsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :update_index, :edit, :update]
  before_action :set_session_b, only: [:edit, :update]
  before_action :redirect_if_not_member

  def index
    @tasks = Task.where(:project_id => session[:project_id])
    @teams = Team.where(:project_id => session[:project_id])
    @potential_allocations = PotentialAllocation.where(:project_id => session[:project_id])

    @capacity_conflicts = helpers.get_capacity_conflicts(session[:project_id])
    @unallocated_conflicts = helpers.get_unallocated_conflicts(session[:project_id])

    if params[:type] != nil
      session[:potential_allocation_type] = params[:type]
    elsif session[:potential_allocation_type] == nil
      session[:potential_allocation_type] = "Task"
    end
  end

  def edit
    set_generation_variables
  end

  def update
    failed_updates = []

    if session[:potential_allocation_type] == "Team"
      Task.where(:project_id => session[:project_id]).each do |task|
        resource = PotentialAllocation.find_by(:team_id => params[:id], :task_id => task.id)

        if resource == nil
          resource = PotentialAllocation.new(
            project_id: session[:project_id],
            task_id: task.id,
            team_id: params[:id]
          )
        end

        resource.duration = params[:values][task.id.to_s][:duration]
        resource.capacity = params[:values][task.id.to_s][:capacity]

        if resource.duration.blank? and resource.capacity.blank?
          resource.destroy
        elsif !resource.save
          failed_updates.push(task.id)
        end
      end
    else
      Team.where(:project_id => session[:project_id]).each do |team|
        resource = PotentialAllocation.find_by(:task_id => params[:id], :team_id => team.id)

        if resource == nil
          resource = PotentialAllocation.new(
            project_id: session[:project_id],
            task_id: params[:id],
            team_id: team.id
          )
        end

        resource.duration = params[:values][team.id.to_s][:duration]
        resource.capacity = params[:values][team.id.to_s][:capacity]

        if resource.duration.blank? and resource.capacity.blank?
          resource.destroy
        elsif !resource.save
          failed_updates.push(team.id)
        end
      end
    end

    if failed_updates.count == 0
      flash.alert = "Successfully updated all allocations"
      redirect_to potential_allocations_path
    else
      if session[:potential_allocation_type] == "Team"
        flash.alert = "Failed to update allocations for tasks " + failed_updates.to_s
      else
        flash.alert = "Failed to update allocations for teams " + failed_updates.to_s
      end

      set_generation_variables

      render "edit"
    end

  end

  private
    def set_session
      session[:project_id] = PotentialAllocation.find(params[:id]).project_id
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def set_session_b
      if session[:potential_allocation_type] == "Team"
        session[:project_id] = Team.find(params[:id]).project_id
      else
        session[:project_id] = Task.find(params[:id]).project_id
      end

      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def set_generation_variables
      if session[:potential_allocation_type] == "Team"
        @current_team = Team.find(params[:id])
        @tasks = Task.where(:project_id => session[:project_id])
        @resources = PotentialAllocation.where(:team_id => params[:id])
      else
        @current_task = Task.find(params[:id])
        @teams = Team.where(:project_id => session[:project_id])
        @resources = PotentialAllocation.where(:task_id => params[:id])
      end

      @capacity_conflicts = helpers.get_capacity_conflicts(session[:project_id])
      @unallocated_conflicts = helpers.get_unallocated_conflicts(session[:project_id])
    end

    def potential_allocation_params
      params.require(:potential_allocation).permit(:task_id, :team_id, :duration, :capacity)
    end
end
