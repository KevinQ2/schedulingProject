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


  # POST/UPDATE/DELETE actions
  # normal testing
  test "POST create if user is host or can_edit in and input is valid" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    assert_difference("Task.count", 1) do
      post tasks_path, params: { task: {
        title: "my new task",
        description: "my description"
        }
      }
    end

    assert_redirected_to tasks_path
  end

  test "PATCH update if user is host or can_edit, and input is valid" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    task = tasks(:one_one_one)

    old_title = task.title
    old_description = task.description
    new_title = "new title"
    new_description = "my description"

    patch task_path(task.id), params: { task: {
      title: new_title,
      description: new_description
      }
    }

    task.reload
    assert_equal(task.title, new_title)
    assert_equal(task.description, new_description)
    assert_redirected_to tasks_path
  end

  test "DELETE destroy if user is host or can_edit" do
    log_in_as(users(:one))
    set_project(projects(:one_one))

    assert_difference("Task.count", -1) do
      delete task_path(tasks(:one_one_one).id)
    end

    assert_redirected_to tasks_path
  end

  # not logged in testing
  test "POST create should redirect to login if not logged in" do
    set_project(projects(:one_one))

    assert_no_difference("Task.count") do
      post tasks_path, params: { task: {
        title: "my new task",
        description: 5
        }
      }
    end

    assert_redirected_to login_path
  end

  test "PATCH update should redirect to login if not logged in" do
    set_project(projects(:one_one))

    task = tasks(:one_one_one)

    old_title = task.title
    old_description = task.description
    new_title = "new title"
    new_description = "my description"

    patch task_path(task.id), params: { task: {
      title: new_title,
      description: new_description
      }
    }

    task.reload
    assert_equal(task.title, old_title)
    assert_equal(task.description, old_description)
    assert_redirected_to login_path
  end

  test "DELETE destroy should redirect to login if not logged in" do
    set_project(projects(:one_one))

    assert_no_difference("Task.count") do
      delete task_path(tasks(:one_one_one).id)
    end

    assert_redirected_to login_path
  end

  # not member testing
  test "POST create should redirect to organization index if not a member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    assert_no_difference("Task.count") do
      post tasks_path, params: { task: {
        title: "my new task",
        description: 5
        }
      }
    end

    assert_redirected_to organizations_path
  end

  test "PATCH update should redirect to organization index if not a member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    task = tasks(:one_one_one)

    old_title = task.title
    old_description = task.description
    new_title = "new title"
    new_description = "my description"

    patch task_path(task.id), params: { task: {
      title: new_title,
      description: new_description
      }
    }

    task.reload
    assert_equal(task.title, old_title)
    assert_equal(task.description, old_description)
    assert_redirected_to organizations_path
  end

  test "DELETE destroy should redirect to organization index if not a member" do
    log_in_as(users(:five))
    set_project(projects(:one_one))

    assert_no_difference("Task.count") do
      delete task_path(tasks(:one_one_one).id)
    end

    assert_redirected_to organizations_path
  end

  # not permission testing
  test "POST create should redirect to index if not host or cannot edit" do
    log_in_as(users(:four))
    set_project(projects(:one_one))

    assert_no_difference("Task.count") do
      post tasks_path, params: { task: {
        title: "my new task",
        description: 5
        }
      }
    end

    assert_redirected_to tasks_path
  end

  test "PATCH update should redirect to index if not host or cannot edit" do
    log_in_as(users(:four))
    set_project(projects(:one_one))

    task = tasks(:one_one_one)

    old_title = task.title
    old_description = task.description
    new_title = "new title"
    new_description = "my description"

    patch task_path(task.id), params: { task: {
      title: new_title,
      description: new_description
      }
    }

    task.reload
    assert_equal(task.title, old_title)
    assert_equal(task.description, old_description)
    assert_redirected_to tasks_path
  end

  test "DELETE destroy should redirect to index if not host or cannot edit" do
    log_in_as(users(:four))
    set_project(projects(:one_one))

    assert_no_difference("Task.count") do
      delete task_path(tasks(:one_one_one).id)
    end

    assert_redirected_to tasks_path
  end
end
