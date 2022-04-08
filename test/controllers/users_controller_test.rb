require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get employees_index_url
    assert_response :success
  end

  test "should get show" do
    get employees_show_url
    assert_response :success
  end

  test "should get delete" do
    get employees_delete_url
    assert_response :success
  end

end
