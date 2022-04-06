require 'test_helper'

class ScheduleAllocationTest < ActiveSupport::TestCase
  def setup
    @schedule = ScheduleAllocation.new(
      project: projects(:one_one),
      potential_allocation: potential_allocations(:one_one_one),
      start_date: 0,
      end_date: potential_allocations(:one_one_one).duration
    )
  end

  test "@schedule should be valid" do
    assert @schedule.valid?
  end

  test "project should not be blank" do
    @schedule.project_id = ""
    assert_not @schedule.valid?
  end

  test "project should exist" do
    @schedule.project_id = 99
    assert_not @schedule.valid?
  end

  test "potential_allocation should not be blank" do
    @schedule.potential_allocation_id = ""
    assert_not @schedule.valid?
  end

  test "potential_allocation should exist" do
    @schedule.potential_allocation_id = 99
    assert_not @schedule.valid?
  end

  test "start_date + duration of allocation should be equal to end_date" do
    @schedule.end_date = @schedule.start_date + @schedule.potential_allocation.duration - 1
    assert_not @schedule.valid?

    @schedule.end_date = @schedule.start_date + @schedule.potential_allocation.duration + 1
    assert_not @schedule.valid?
  end

  test "blank start_date should autofill if potential_allocation and end_date are valid" do
    @schedule.end_date = ""
    assert @schedule.valid?
    assert_equal(@schedule.start_date + @schedule.potential_allocation.duration, @schedule.end_date)
  end

  test "blank end_date should autofill if potential_allocation and start_date are valid" do
    @schedule.start_date = ""
    assert @schedule.valid?
    assert_equal(@schedule.start_date + @schedule.potential_allocation.duration, @schedule.end_date)
  end

  test "start_date and end_date should not be both blank" do
    @schedule.start_date = ""
    @schedule.end_date = ""
    assert_not @schedule.valid?
  end

  test "start_date should be numeric" do
    @schedule.start_date = "one"
    assert_not @schedule.valid?
  end

  test "start_date should be 0 or greater" do
    @schedule.start_date = -1
    @schedule.end_date = ""
    assert_not @schedule.valid?
  end

  test "start_date can be 0" do
    @schedule.start_date = 0
    @schedule.end_date = ""
    assert @schedule.valid?
  end

  test "end_date should be numeric" do
    @schedule.end_date = "one"
    assert_not @schedule.valid?
  end
end
