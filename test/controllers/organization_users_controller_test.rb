require 'test_helper'

class OrganizationUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organization_users_index_url
    assert_response :success
  end

  test "should get new" do
    get organization_users_new_url
    assert_response :success
  end

  test "should get show" do
    get organization_users_show_url
    assert_response :success
  end

  test "should get edit" do
    get organization_users_edit_url
    assert_response :success
  end

  test "should get delete" do
    get organization_users_delete_url
    assert_response :success
  end

end
