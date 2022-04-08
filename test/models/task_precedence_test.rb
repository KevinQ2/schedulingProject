require 'test_helper'

class TaskPrecedenceTest < ActiveSupport::TestCase
  def setup
    @precedence = TaskPrecedence.new(
      task_id: tasks(:one_one_one).id,
      required_task_id: tasks(:one_one_two).id
    )
  end

  test "@precedence should be valid" do
    assert @precedence.valid?
  end

  test "task and required task should not be the same" do
    @precedence.task_id = @precedence.required_task_id
    assert_not @precedence.valid?
  end

  test "task should be unique in the scope of a required task" do
    @precedence.save
    new_precedence = @precedence.dup
    assert_not new_precedence.valid?
  end

  test "task and required_task should belong in the same project" do
    @precedence.required_task_id = tasks(:one_two_one).id
    assert_not @precedence.valid?
  end

  test "task should not be blank" do
    @precedence.task_id = ""
    assert_not @precedence.valid?
  end

  test "task should exist" do
    @precedence.task_id = 99
    assert_not @precedence.valid?
  end

  test "required task should not be blank" do
    @precedence.required_task_id = ""
    assert_not @precedence.valid?
  end

  test "required task should exist" do
    @precedence.required_task_id = 99
    assert_not @precedence.valid?
  end
end
