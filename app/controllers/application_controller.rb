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
      redirect_to "/home"
    end
  end
end
