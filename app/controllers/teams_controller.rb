class TeamsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member

  def index
    @teams = Team.where(:project => session[:project_id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.project_id = session[:project_id]

    if @team.save
      redirect_to teams_path
    else
      render "new"
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.attributes = team_params

    if @team.save
      redirect_to teams_path
    else
      render "edit"
    end
  end

  def delete
    @team = Team.find(params[:id])
  end

  def destroy
    team = Team.find(params[:id])
    project_id = team.project_id

    team.destroy
    redirect_to teams_path
  end

  private
    def set_session
      session[:project_id] = Team.find(params[:id]).project_id
      session[:organization_id] = Project.find(session[:project_id]).organization_id
    end

    def team_params
      params.require(:team).permit(:name, :population)
    end
end
