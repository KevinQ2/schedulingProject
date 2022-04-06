class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?

  def current_user
    if session[:username]
      User.find_by(username: session[:username])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def redirect_if_not_logged_in
    if !logged_in?
      redirect_to "/login"
    end
  end

  def redirect_if_not_member
    if !OrganizationMember.exists?(:organization_id => session[:organization_id], :user_id => current_user.id)
      flash.alert = "You are not authorised"
      redirect_to organizations_path
    end
  end

  def redirect_if_not_host
    if !helpers.is_host_member?(session[:organization_id])
      flash.alert = "You are not authorised"
      current_controller = controller_name()

      if current_controller == "organizations"
        redirect_to organizations_path
      elsif current_controller == "organization_members"
        redirect_to organization_members_path
      end
    end
  end

  def redirect_if_not_edit
    if !helpers.is_edit_member?(session[:organization_id])
      flash.alert = "You are not authorised"
      current_controller = controller_name()

      if current_controller == "organizations"
        redirect_to organizations_path
      elsif current_controller == "projects"
        redirect_to organization_path(session[:organization_id])
      elsif current_controller == "tasks"
        redirect_to tasks_path
      elsif current_controller == "teams"
        redirect_to teams_path
      elsif current_controller == "potential_allocations"
        redirect_to potential_allocations_path
      end
    end
  end

  def redirect_if_not_invite
    if !helpers.is_invite_member?(session[:organization_id])
      flash.alert = "You are not authorised"
      redirect_to organization_members_path
    end
  end
end
