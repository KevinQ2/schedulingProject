require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  # GET actions
  # normal testing
  test "GET index if user is a member" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    get tasks_path
    assert_response :success
  end

  test "GET new if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get new_task_path
    assert_response :success
  end

  test "GET edit if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get edit_task_path(tasks(:one_one_one))
    assert_response :success
  end

  test "GET edit_precedences if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get edit_precedences_task_path(tasks(:one_one_one))
    assert_response :success
  end

  test "GET delete if host or can edit" do
    log_in_as(users(:two))
    set_project(projects(:one_one))

    get delete_task_path(tasks(:one_one_one))
    assert_response :success
  end

  # not logged in testing
  test "GET index should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get tasks_path
    assert_redirected_to login_path
  end

  test "GET new should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get new_task_path
    assert_redirected_to login_path
  end

  test "GET edit should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get edit_task_path(tasks(:one_one_one))
    assert_redirected_to login_path
  end

  test "GET edit_precedences should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get edit_precedences_task_path(tasks(:one_one_one))
    assert_redirected_to login_path
  end

  test "GET delete should redirect to login if not logged in" do
    set_project(projects(:one_one))
    get delete_task_path(tasks(:one_one_one))
    assert_redirected_to login_path
  end

  # not member testing
  test "GET index should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get tasks_path
    assert_redirected_to organizations_path
  end

  test "GET new should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get new_task_path
    assert_redirected_to organizations_path
  end

  test "GET edit should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get edit_task_path(tasks(:one_one_one))
    assert_redirected_to organizations_path
  end

  test "GET edit_precedences should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get edit_precedences_task_path(tasks(:one_one_one))
    assert_redirected_to organizations_path
  end

  test "GET delete should redirect to organization index if not member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    get delete_task_path(tasks(:one_one_one))
    assert_redirected_to organizations_path
  end

  # not permission testing
  test "GET new should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get new_task_path
    assert_redirected_to tasks_path
  end

  test "GET edit should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get edit_task_path(tasks(:one_one_one))
    assert_redirected_to tasks_path
  end

  test "GET edit_precedences should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get edit_precedences_task_path(tasks(:one_one_one))
    assert_redirected_to tasks_path
  end

  test "GET delete should redirect to index if not host or can edit" do
    log_in_as(users(:three))
    set_project(projects(:one_one))

    get delete_task_path(tasks(:one_one_one))
    assert_redirected_to tasks_path
  end


end
