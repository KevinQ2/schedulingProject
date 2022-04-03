require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @task = Task.new(
      project: projects(:one_one),
      title: "taskA",
      description: "my description"
    )
  end

  test "@task should be valid" do
    assert @task.valid?
  end

  test "project should not be blank" do
    @task.project_id = ""
    assert_not @task.valid?
  end

  test "project should exist" do
    @task.project_id = 99
    assert_not @task.valid?
  end

  test "title should be unique in the scope of the project" do
    @task.save
    new_task = @task.dup
    assert_not new_task.valid?
  end

  test "title should not be blank" do
    @task.title = ""
    assert_not @task.valid?
  end

  test "description can be blank" do
    @task.description = ""
    assert @task.valid?
  end
end
