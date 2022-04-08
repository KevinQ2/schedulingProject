ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:username].nil?
  end
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: "mypassword")
    post "/login", params: { username: user.username, password: password }
  end

  def set_organization(organization)
    get organization_path(organization)
  end

  def set_project(project)
    get project_path(project)
  end
end
