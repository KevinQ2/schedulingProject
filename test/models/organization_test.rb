require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @organization = Organization.new(:name => "organization test")
  end

  test "@organization should be valid" do
    assert @organization.valid?
  end

  test "name should not be blank" do
    @organization.name = ""
    assert_not @organization.valid?
  end

  test "name should not be less than 1 characters" do
    @organization.name = "a" * 0
    assert_not @user.valid?
  end

  test "name can be 1 characters" do
    @organization.name = "a"
    assert @user.valid?
  end

  test "name should not be longer than 30 characters" do
    @organization.name = "a" * 31
    assert_not @user.valid?
  end

  test "name can be 30 characters" do
    @organization.name = "a" * 30
    assert @user.valid?
  end
end
