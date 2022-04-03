require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = Team.new(
      project: projects(:one_one),
      name: "Team A",
      population: 5
    )
  end

  test "@team should be valid" do
    assert @team.valid?
  end

  test "project should not be blank" do
    @team.project_id = ""
    assert_not @team.valid?
  end

  test "project should exist" do
    @team.project_id = 99
    assert_not @team.valid?
  end

  test "name should be unique in the scope of the project" do
    @team.save
    new_team = @team.dup
    assert_not new_team.valid?
  end

  test "name should not be blank" do
    @team.name = ""
    assert_not @team.valid?
  end

  test "population should not be blank" do
    @team.population = ""
    assert_not @team.valid?
  end

  test "population should be numeric" do
    @team.population = "one"
    assert_not @team.valid?
  end

  test "population should not be less than 1" do
    @team.population = 0
    assert_not @team.valid?
  end

  test "population can be 1" do
    @team.population = 1
    assert @team.valid?
  end
end
