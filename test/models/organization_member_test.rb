require 'test_helper'

class OrganizationMemberTest < ActiveSupport::TestCase
  def setup
    @member = OrganizationMember.new(
      organization: organizations(:two),
      user: users(:one)
    )
  end

  test "@member should be valid" do
    assert @member.valid?
  end

  test "user should not be unique in the scope of an organization" do
    @member.save
    new_member = @member.dup
    assert_not new_member.valid?
  end

  test "organization should not be blank" do
    @member.organization_id = ""
    assert_not @member.valid?
  end

  test "organization should exist" do
    @member.organization_id = 99
    assert_not @member.valid?
  end

  test "user should not be blank" do
    @member.user_id = ""
    assert_not @member.valid?
  end

  test "user should exist" do
    @member.user_id = 99
    assert_not @member.valid?
  end
end
