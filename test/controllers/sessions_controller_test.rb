require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get "/login"
    assert_response :success
  end

  test "should not redirect to /home if values are invalid" do
    post login_path, params: {
      username: "bobc",
      password: "invalid"
    }

    assert_redirected_to "/login"
    assert_not is_logged_in?
  end

  test "create should redirect to /home if values are valid" do
    post login_path, params: {
      username: "bobc",
      password: "mypassword"
    }
    
    assert_redirected_to "/home"
    assert is_logged_in?
  end

  test "destroy should logout current user" do
    log_in_as(users(:one))
    assert is_logged_in?

    delete logout_path
    assert_not is_logged_in?
  end

end
