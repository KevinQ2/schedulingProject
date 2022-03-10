class TaskResourcesController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :update_index, :edit, :update]
  before_action :set_session_b, only: [:edit, :update]
  before_action :redirect_if_not_member

  def index
    @tasks = Task.where(:project_id => session[:project_id])
    @human_resources = HumanResource.where(:project_id => session[:project_id])
    @task_resources = TaskResource.where(:project_id => session[:project_id])

    @capacity_conflicts = helpers.get_capacity_conflicts(session[:project_id])
    @unallocated_conflicts = helpers.get_unallocated_conflicts(session[:project_id])

    if session[:task_resource_type] == nil
      session[:task_resource_type] = "Task"
    end

  end

  def update_index
    @tasks = Task.where(:project_id => session[:project_id])
    @human_resources = HumanResource.where(:project_id => session[:project_id])
    @task_resources = TaskResource.where(:project_id => session[:project_id])

    @capacity_conflicts = helpers.get_capacity_conflicts(session[:project_id])
    @unallocated_conflicts = helpers.get_unallocated_conflicts(session[:project_id])

    session[:task_resource_type] = params[:type]
    render "index"
  end

  def edit
    @tasks = Task.where(:project_id => session[:project_id])
    @human_resources = HumanResource.where(:project_id => session[:project_id])

    @capacity_conflicts = helpers.get_capacity_conflicts(session[:project_id])
    @unallocated_conflicts = helpers.get_unallocated_conflicts(session[:project_id])
  end

  def update
    @tasks = Task.where(:project_id => session[:project_id])
    @human_resources = HumanResource.where(:project_id => session[:project_id])

    @capacity_conflicts = helpers.get_capacity_conflicts(session[:project_id])
    @unallocated_conflicts = helpers.get_unallocated_conflicts(session[:project_id])

    failed_updates = []

    if session[:task_resource_type] == "Human resource"
      Task.where(:project_id => session[:project_id]).each do |task|
        resource = TaskResource.find_by(:human_resource_id => params[:id], :task_id => task.id)

        if resource == nil
          resource = TaskResource.new(
            project_id: session[:project_id],
            task_id: task.id,
            human_resource_id: params[:id]
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
      HumanResource.where(:project_id => session[:project_id]).each do |human_resource|
        resource = TaskResource.find_by(:task_id => params[:id], :human_resource_id => human_resource.id)

        if resource == nil
          resource = TaskResource.new(
            project_id: session[:project_id],
            task_id: params[:id],
            human_resource_id: human_resource.id
          )
        end

        resource.duration = params[:values][human_resource.id.to_s][:duration]
        resource.capacity = params[:values][human_resource.id.to_s][:capacity]

        if resource.duration.blank? and resource.capacity.blank?
          resource.destroy
        elsif !resource.save
          failed_updates.push(human_resource.id)
        end
      end
    end

    if failed_updates.count == 0
      flash.alert = "Successfully updated all allocations"
      redirect_to task_resources_path
    else
      if session[:task_resource_type] == "Human resource"
        flash.alert = "Failed to update allocations for tasks " + failed_updates.to_s
      else
        flash.alert = "Failed to update allocations for human resources " + failed_updates.to_s
      end

      render "edit"
    end

  end

  private
    def set_session
      session[:project_id] = TaskResource.find(params[:id]).project_id
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def set_session_b
      if session[:task_resource_type] == "Human resource"
        session[:project_id] = HumanResource.find(params[:id]).project_id
      else
        session[:project_id] = Task.find(params[:id]).project_id
      end

      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def task_resource_params
      params.require(:task_resource).permit(:task_id, :human_resource_id, :duration, :capacity)
    end
end
