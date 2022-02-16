class ProjectsController < ApplicationController
  before_action :redirect_if_not_logged_in

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
    @project = Project.new(task_params)
    @project.organization_id = params[:id]

    if @project.save
      redirect_to "/organization/#{params[:id]}/projects"
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def schedule
    @project = Project.find(params[:id])
  end

  def delete
    @project = Project.find(params[:id])
  end

  private
    def project_params
      params.require(:project).permit(:name)
    end
end
