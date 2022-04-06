require 'test_helper'

class HomePageControllerTest < ActionDispatch::IntegrationTest
  test "should get index if logged in" do
    user = users(:one)
    log_in_as(user)
    get "/home"
    assert_response :success
  end

  test "get index should redirect to /login if not logged in" do
    get "/home"
    assert_redirected_to login_path
  end

end
