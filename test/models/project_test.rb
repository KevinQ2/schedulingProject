require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def setup
    @project = Project.new(
      organization: organizations(:one),
      name: "project1"
    )

    @project2 = Project.new(
      organization: organizations(:two),
      name: "project2"
    )
  end

  test "@project should be valid" do
    assert @project.valid?
  end

  test "@project2 should be valid" do
    assert @project2.valid?
  end

  test "organization should not be blank" do
    @project.organization_id = ""
    assert_not @project.valid?, @project.errors.messages
  end

  test "organization should exist" do
    @project.organization_id = 99
    assert_not @project.valid?
  end

  test "name should not be blank" do
    @project.name = ""
    assert_not @project.valid?
  end

  test "name should be unique within the scope of an organization" do
    @project.save
    new_project = @project.dup
    assert_not new_project.valid?
  end

  test "name can be identical to projects from other organizations" do
    @project.save
    new_project = @project.dup
    new_project.organization = organizations(:two)
    assert new_project.valid?
  end

end
