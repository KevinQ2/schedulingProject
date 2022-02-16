class HumanResourcesController < ApplicationController
  def index
    @human_resources = HumanResource.where(:project => params[:id])
  end

  def show
    @human_resource = HumanResource.find(params[:id])
  end

  def new
    @human_resource = HumanResource.new
  end

  def create
    @human_resource = HumanResource.new(human_resource_params)
    @human_resource.project_id = params[:id]

    if @human_resource.save
      redirect_to "/project/#{params[:id]}/human_resources"
    else
      render "new"
    end
  end

  def edit
    @human_resource = HumanResource.find(params[:id])
  end

  def delete
    @human_resource = HumanResource.find(params[:id])
  end

  private
    def human_resource_params
      params.require(:human_resource).permit(:name, :instances)
    end
end
