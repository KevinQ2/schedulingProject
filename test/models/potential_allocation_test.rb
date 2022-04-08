require 'test_helper'

class PotentialAllocationTest < ActiveSupport::TestCase
  def setup
    @allocation = PotentialAllocation.new(
      project: projects(:one_one),
      task: tasks(:one_one_two),
      team: teams(:one_one_two),
      duration: 5,
      capacity: 3
    )
  end

  test "@allocation should be valid" do
    assert @allocation.valid?
  end

  test "task should be unique in the scope of a team" do
    @allocation.save
    new_allocation = @allocation.dup
    assert_not new_allocation.valid?
  end

  test "task and team should belong to the same project" do
    @allocation.team = teams(:one_two_one)
    assert_not @allocation.valid?
  end

  test "project should not be blank" do
    @allocation.project_id = ""
    assert_not @allocation.valid?
  end

  test "project should exist" do
    @allocation.project_id = 99
    assert_not @allocation.valid?
  end

  test "task should not be blank" do
    @allocation.task_id = ""
    assert_not @allocation.valid?
  end

  test "task should exist" do
    @allocation.task_id = 99
    assert_not @allocation.valid?
  end

  test "team should not be blank" do
    @allocation.team_id = ""
    assert_not @allocation.valid?
  end

  test "team should exist" do
    @allocation.team_id = 99
    assert_not @allocation.valid?
  end

  test "duration should not be blank" do
    @allocation.duration = ""
    assert_not @allocation.valid?
  end

  test "duration should not be numeric" do
    @allocation.duration = "one"
    assert_not @allocation.valid?
  end

  test "duration should greater than 0" do
    @allocation.duration = 0
    assert_not @allocation.valid?
  end

  test "duration can be 1" do
    @allocation.duration = 1
    assert @allocation.valid?
  end

  test "capacity should not be blank" do
    @allocation.capacity = ""
    assert_not @allocation.valid?
  end

  test "capacity should not be numeric" do
    @allocation.capacity = "one"
    assert_not @allocation.valid?
  end

  test "capacity should greater than 0" do
    @allocation.capacity = 0
    assert_not @allocation.valid?
  end

  test "capacity can be 1" do
    @allocation.capacity = 1
    assert @allocation.valid?
  end

  test "capacity should not be greater than the team's population" do
    @allocation.capacity = @allocation.team.population + 1
    assert_not @allocation.valid?
  end

  test "capacity can be equal to the team's population" do
    @allocation.capacity = @allocation.team.population
    assert @allocation.valid?
  end
end
