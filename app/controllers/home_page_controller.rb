class HomePageController < ApplicationController
  before_action :redirect_if_not_logged_in

  def index
    @user = current_user
  end
end
