require 'test_helper'

class OrganizationMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organization_members_index_url
    assert_response :success
  end

  test "should get new" do
    get new_organization_member_url
    assert_response :success
  end

  test "should get show" do
    get organization_members_show_url
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_member_url
    assert_response :success
  end

  test "should get delete" do
    get organization_members_delete_url
    assert_response :success
  end

end
