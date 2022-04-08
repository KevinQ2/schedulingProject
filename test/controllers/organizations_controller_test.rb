require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  # GET actions
  # normal testing
  test "GET index if logged in" do
    log_in_as(users(:one))
    get organizations_path
    assert_response :success
  end

  test "GET show if user belongs to the organization" do
    log_in_as(users(:one))
    get organization_path(organizations(:one))
    assert_response :success
  end

  test "GET new if user is logged in" do
    log_in_as(users(:one))
    get organizations_path
    assert_response :success
  end

  test "GET edit if current user is host in the organization" do
    log_in_as(users(:one))
    get edit_organization_path(organizations(:one))
    assert_response :success
  end

  test "GET delete if user is host in the organization" do
    log_in_as(users(:one))
    get delete_organization_path(organizations(:one))
    assert_response :success
  end

  # not logged in tests
  test "GET index should redirect to login if not logged in" do
    get organizations_path
    assert_redirected_to login_path
  end

  test "GET show should redirect to login if not logged in" do
    get organization_path(organizations(:one))
    assert_redirected_to login_path
  end

  test "GET new should redirect to login if not logged in" do
    get new_organization_path
    assert_redirected_to login_path
  end

  test "GET edit should redirect to login if not logged in" do
    get edit_organization_path(organizations(:one))
    assert_redirected_to login_path
  end

  test "GET delete should redirect to login if not logged in" do
    get delete_organization_path(organizations(:one))
    assert_redirected_to login_path
  end

  # not member testing
  test "GET show should redirect to index if user does not belongs to the organization" do
    log_in_as(users(:one))
    get organization_path(organizations(:two))
    assert_redirected_to organizations_path
  end

  test "GET edit should redirect to index if user does not belong to the organization" do
    log_in_as(users(:one))
    get edit_organization_path(organizations(:two))
    assert_redirected_to organizations_path
  end

  test "GET delete should redirect to index if user does not belong to the organization" do
    log_in_as(users(:one))
    get delete_organization_path(organizations(:two))
    assert_redirected_to organizations_path
  end

  # not permission testing
  test "GET edit should redirect to index if current user is not host in the organization" do
    log_in_as(users(:two))
    get edit_organization_path(organizations(:one))
    assert_redirected_to organizations_path
  end

  test "GET delete should redirect to index if current user is not host in the organization" do
    log_in_as(users(:two))
    get delete_organization_path(organizations(:one))
    assert_redirected_to organizations_path
  end


  # POST/UPDATE/DELETE actions
  # normal testing
  test "POST create if user is logged in and input is valid" do
    log_in_as(users(:one))

    assert_difference("Organization.count", 1) do
      post organizations_path, params: { organization: {
        name: "my new organization"
        }
      }
    end

    assert_redirected_to organizations_path
  end

  test "PATCH update if user is host and input is valid" do
    log_in_as(users(:one))
    organization = organizations(:one)

    old_name = organization.name
    new_name = "updated name"

    patch organization_path(organization.id), params: { organization: {
      name: new_name
      }
    }

    organization.reload
    assert_equal(organization.name, new_name)
  end

  test "DELETE destroy if user is host" do
    log_in_as(users(:one))

    assert_difference("Organization.count", -1) do
      delete organization_path(organizations(:one).id)
    end

    assert_redirected_to organizations_path
  end


  # not logged in testing
  test "POST create should redirect to login if user is not logged in and input is valid" do
    assert_no_difference("Organization.count") do
      post organizations_path, params: { organization: {
        name: "my new organization"
        }
      }
    end

    assert_redirected_to login_path
  end

  test "PATCH update should redirect to login if user is not logged in and input is valid" do
    organization = organizations(:one)

    old_name = organization.name
    new_name = "updated name"

    patch organization_path(organization.id), params: { organization: {
      name: new_name
      }
    }

    organization.reload
    assert_equal(organization.name, old_name)
  end

  test "DELETE destroy should redirect to login if user is not logged in and input is valid" do
    assert_no_difference("Organization.count") do
      delete organization_path(organizations(:one).id)
    end

    assert_redirected_to login_path
  end

  # invalid input testing
  test "POST create should not work if user is host but invalid input" do
    log_in_as(users(:one))
    assert_no_difference("Organization.count") do
      post organizations_path, params: { organization: {
        name: ""
        }
      }
    end
  end

  test "PATCH update should not work if user is host but invalid input" do
    log_in_as(users(:one))
    organization = organizations(:one)

    old_name = organization.name
    new_name = ""

    patch organization_path(organization.id), params: { organization: {
      name: new_name
      }
    }

    organization.reload
    assert_equal(organization.name, old_name)
  end

  # not member testing
  test "PATCH update should redirect to index if user is not a member of the organization" do
    log_in_as(users(:one))
    organization = organizations(:two)

    old_name = organization.name
    new_name = "updated name"

    patch organization_path(organization.id), params: { organization: {
      name: new_name
      }
    }

    organization.reload
    assert_equal(organization.name, old_name)
    assert_redirected_to organizations_path
  end

  test "DELETE destroy should redirect to index if user is not a member of the organization" do
    log_in_as(users(:one))
    assert_no_difference("Organization.count") do
      delete organization_path(organizations(:two).id)
    end

    assert_redirected_to organizations_path
  end

  # not permission testing
  test "PATCH update should redirect to index if user is not a host of the organization" do
    log_in_as(users(:two))
    organization = organizations(:one)

    old_name = organization.name
    new_name = "updated name"

    patch organization_path(organization.id), params: { organization: {
      name: new_name
      }
    }

    organization.reload
    assert_equal(organization.name, old_name)
    assert_redirected_to organizations_path
  end

  test "DELETE destroy should redirect to index if user is not a host of the organization" do
    log_in_as(users(:two))
    assert_no_difference("Organization.count") do
      delete organization_path(organizations(:one).id)
    end

    assert_redirected_to organizations_path
  end

end
