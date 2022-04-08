class ProjectsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:new, :create, :generate_random, :create_random]
  before_action :redirect_if_not_member
  before_action :redirect_if_not_edit, except: [:show, :compare_algorithms]

  def show
    set_show_variables
  end

  def compare_algorithms
    set_show_variables

    if @capacity_conflicts.count == 0 and @cycle_conflicts.count == 0 and @unallocated_conflicts.count == 0
      @schemes = params[:schemes]
      @schemes.delete("")
      @priority_rules = params[:priority_rules]
      @priority_rules.delete("")
      @schedules = []

      if !@schemes.nil? and !@priority_rules.nil? and !@sampling.nil?
        priority_hash = {}

        @priority_rules.each do |rule|
          scheme_hash = {}

          @schemes.each do |scheme|
            # scheme -> {schedule}
            schedule = helpers.generate_schedule(@project, scheme, rule, "none", nil) #[schedule, running time]
            scheme_hash[scheme] = [schedule[0].max_by{|k, v| v[0]}[1][0], schedule[1]] # scheme -> [schedule length, running time]
          end

          # [rule, {scheme -> [project length, running time]}]
          priority_hash[rule] = scheme_hash
        end

        @schedules = priority_hash
      end
    end

    render "show"
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

  def generate_random
    @project = Project.new
    @generate_project = GenerateProject.new
  end

  def create_random
    @project = Project.new(project_params)
    @project.organization_id = session[:organization_id]

    @generate_project = GenerateProject.new(project_generation_params)

    # reassignment ensures both validation checks occur
    # this ensures error messages are generated
    valid = @project.validate
    valid = @generate_project.validate and valid

    if valid
      helpers.generate_project(@project, @generate_project)
      redirect_to organization_path(session[:organization_id])
    else
      render "generate_random"
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

  private
    def redirect_if_not_authorised
      unless OrganizationMember.exists?(:user_id => current_user.id, :organization_id => Project.find(params[:id]).organization_id)
        redirect_to '/home'
      end
    end

    def set_session
      session[:project_id] = params[:id]
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def set_show_variables
      @can_edit = helpers.is_edit_member?(session[:organization_id])

      @project = Project.find(params[:id])
      @capacity_conflicts = helpers.get_capacity_conflicts(@project.id)
      @cycle_conflicts = helpers.get_cycles(@project.id)
      @unallocated_conflicts = helpers.get_unallocated_conflicts(@project.id)

      # stores fields and schedules of algorithms being compared
      @schemes = params[:schemes]
      @priority_rules = params[:priority_rules]
      @sampling = params[:sampling]
      @schedules = params[:schedules]

      @schemes = [] if @schemes.nil?
      @priority_rules = [] if @priority_rules.nil?
      @sampling = [] if @sampling.nil?
      @schedules = [] if @schedules.nil?
    end

    def project_params
      params.require(:project).permit(:name)
    end

    def project_generation_params
      params.require(:generate_project).permit(:initial_task, :task_count, :max_prec, :t_count, :t_population_min, :t_population_max, :duration_min, :duration_max, :a_chance)
    end
end
