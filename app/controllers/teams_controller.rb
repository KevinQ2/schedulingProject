class TeamsController < ApplicationController
  before_action :redirect_if_not_logged_in
  before_action :set_session, except: [:index, :new, :create]
  before_action :redirect_if_not_member
  before_action :redirect_if_not_edit, except: [:index]

  def index
    @teams = Team.where(:project => session[:project_id])
    @can_edit = helpers.is_edit_member?(session[:organization_id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.project_id = session[:project_id]

    if @team.save
      # changes to project environment outdates the schedule
      helpers.clear_schedule(@team.project_id)
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
      # changes to project environment outdates the schedule
      helpers.clear_schedule(@team.project_id)
      redirect_to teams_path
    else
      render "edit"
    end
  end

  def delete
    @team = Team.find(params[:id])
  end

  def destroy
    # changes to project environment outdates the schedule
    @team = Team.find(params[:id])
    helpers.clear_schedule(@team.project_id)
    @team.destroy
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
