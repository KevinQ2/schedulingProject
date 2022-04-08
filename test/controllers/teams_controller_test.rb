require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  # GET actions
  # normal testing
  test "GET index if user is a member" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    get teams_path
    assert_response :success
  end

  test "GET new if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get new_team_path
    assert_response :success
  end

  test "GET edit if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get edit_team_path(teams(:one_one_one))
    assert_response :success
  end

  test "GET delete if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get delete_team_path(teams(:one_one_one))
    assert_response :success
  end

  # not logged in testing
  test "GET index should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get teams_path
    assert_redirected_to login_path
  end

  test "GET new should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get new_team_path
    assert_redirected_to login_path
  end

  test "GET edit should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get edit_team_path(teams(:one_one_one))
    assert_redirected_to login_path
  end

  test "GET delete should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get delete_team_path(teams(:one_one_one))
    assert_redirected_to login_path
  end

  # not member testing
  test "GET index should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get teams_path
    assert_redirected_to organizations_path
  end

  test "GET new should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get new_team_path
    assert_redirected_to organizations_path
  end

  test "GET edit should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get edit_team_path(teams(:one_one_one))
    assert_redirected_to organizations_path
  end

  test "GET delete should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get delete_team_path(teams(:one_one_one))
    assert_redirected_to organizations_path
  end

  # not permission testing
  test "GET new should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get new_team_path
    assert_redirected_to teams_path
  end

  test "GET edit should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get edit_team_path(teams(:one_one_one))
    assert_redirected_to teams_path
  end

  test "GET delete should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get delete_team_path(teams(:one_one_one))
    assert_redirected_to teams_path
  end

  # POST/UPDATE/DELETE actions
  # normal testing
  test "POST create if user is host or can_edit in and input is valid" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    assert_difference("Team.count", 1) do
      post teams_path, params: { team: {
        name: "my new team",
        population: 5
        }
      }
    end

    assert_redirected_to teams_path
  end

  test "PATCH update if user is host or can_edit, and input is valid" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    team = teams(:one_one_one)

    old_name = team.name
    old_population = team.population
    new_name = "new name"
    new_population = 2

    patch team_path(team.id), params: { team: {
      name: new_name,
      population: new_population
      }
    }

    team.reload
    assert_equal(team.name, new_name)
    assert_equal(team.population, new_population)
    assert_redirected_to teams_path
  end

  test "DELETE destroy if user is host or can_edit" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    assert_difference("Team.count", -1) do
      delete team_path(teams(:one_one_one).id)
    end

    assert_redirected_to teams_path
  end

  # not logged in testing
  test "POST create should redirect to login if not logged in" do
    set_project(projects(:one_one))

    assert_no_difference("Team.count") do
      post teams_path, params: { team: {
        name: "my new team",
        population: 5
        }
      }
    end

    assert_redirected_to login_path
  end

  test "PATCH update should redirect to login if not logged in" do
    set_project(projects(:one_one))

    team = teams(:one_one_one)

    old_name = team.name
    old_population = team.population
    new_name = "new name"
    new_population = 2

    patch team_path(team.id), params: { team: {
      name: new_name,
      population: new_population
      }
    }

    team.reload
    assert_equal(team.name, old_name)
    assert_equal(team.population, old_population)
    assert_redirected_to login_path
  end

  test "DELETE destroy should redirect to login if not logged in" do
    set_project(projects(:one_one))

    assert_no_difference("Team.count") do
      delete team_path(teams(:one_one_one).id)
    end

    assert_redirected_to login_path
  end

  # not member testing
  test "POST create should redirect to organization index if not a member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    assert_no_difference("Team.count") do
      post teams_path, params: { team: {
        name: "my new team",
        population: 5
        }
      }
    end

    assert_redirected_to organizations_path
  end

  test "PATCH update should redirect to organization index if not a member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    team = teams(:one_one_one)

    old_name = team.name
    old_population = team.population
    new_name = "new name"
    new_population = 2

    patch team_path(team.id), params: { team: {
      name: new_name,
      population: new_population
      }
    }

    team.reload
    assert_equal(team.name, old_name)
    assert_equal(team.population, old_population)
    assert_redirected_to organizations_path
  end

  test "DELETE destroy should redirect to organization index if not a member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    assert_no_difference("Team.count") do
      delete team_path(teams(:one_one_one).id)
    end

    assert_redirected_to organizations_path
  end

  # not permission testing
  test "POST create should redirect to index if not host or cannot edit" do
    log_in_as(users(:four))
    set_project(projects(:one_one))

    assert_no_difference("Team.count") do
      post teams_path, params: { team: {
        name: "my new team",
        population: 5
        }
      }
    end

    assert_redirected_to teams_path
  end

  test "PATCH update should redirect to index if not host or cannot edit" do
    log_in_as(users(:four))
    set_project(projects(:one_one))

    team = teams(:one_one_one)

    old_name = team.name
    old_population = team.population
    new_name = "new name"
    new_population = 2

    patch team_path(team.id), params: { team: {
      name: new_name,
      population: new_population
      }
    }

    team.reload
    assert_equal(team.name, old_name)
    assert_equal(team.population, old_population)
    assert_redirected_to teams_path
  end

  test "DELETE destroy should redirect to index if not host or cannot edit" do
    log_in_as(users(:four))
    set_project(projects(:one_one))

    assert_no_difference("Team.count") do
      delete team_path(teams(:one_one_one).id)
    end

    assert_redirected_to teams_path
  end
end
