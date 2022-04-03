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
end
