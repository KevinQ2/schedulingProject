require 'test_helper'

class OrganizationMembersControllerTest < ActionDispatch::IntegrationTest

  # GET actions
  # normal testing
  test "GET index if user belongs to organization" do
    log_in_as(users(:four))
    set_organization(organizations(:one))
    get organization_members_path
    assert_response :success
  end

  test "GET new if user is host" do
    log_in_as(users(:one))
    set_organization(organizations(:one))
    get new_organization_member_path
    assert_response :success
  end

  test "GET new if user can invite" do
    log_in_as(users(:three))
    set_organization(organizations(:one))
    get new_organization_member_path
    assert_response :success
  end

  test "GET edit if user is host" do
    log_in_as(users(:one))
    set_organization(organizations(:one))
    get edit_organization_member_path(organization_members(:one_two))
    assert_response :success
  end

  test "GET delete if user is host" do
    log_in_as(users(:one))
    set_organization(organizations(:one))
    get delete_organization_member_path(organization_members(:one_two))
    assert_response :success
  end

  # not logged in testing
  test "GET index should redirect to login if not logged in" do
    get organization_members_path
    assert_redirected_to login_path
  end

  test "GET new should redirect to login if not logged in" do
    get new_organization_member_path
    assert_redirected_to login_path
  end

  test "GET edit should redirect to login if not logged in" do
    get edit_organization_member_path(organization_members(:one_two))
    assert_redirected_to login_path
  end

  test "GET delete should redirect to login if not logged in" do
    get delete_organization_member_path(organization_members(:one_two))
    assert_redirected_to login_path
  end

  # not member testing
  test "GET index should redirect to organization index if user is not a member of the organziation" do
    log_in_as(users(:five))
    set_organization(organizations(:one))

    get organization_members_path
    assert_redirected_to organizations_path
  end

  test "GET new should redirect to organization index if user is not a member of the organziation" do
    log_in_as(users(:five))
    set_organization(organizations(:one))

    get new_organization_member_path
    assert_redirected_to organizations_path
  end

  test "GET edit should redirect to organization index if user is not a member of the organziation" do
    log_in_as(users(:five))
    set_organization(organizations(:one))

    get edit_organization_member_path(organization_members(:one_two))
    assert_redirected_to organizations_path
  end

  test "GET delete should redirect to organization index if user is not a member of the organziation" do
    log_in_as(users(:five))
    set_organization(organizations(:one))

    get delete_organization_member_path(organization_members(:one_two))
    assert_redirected_to organizations_path
  end

  # not permission testing
  test "GET new should redirect to index if not host or cannot invite" do
    log_in_as(users(:two))
    set_organization(organizations(:one))

    get new_organization_member_path
    assert_redirected_to organization_members_path
  end

  test "GET edit should redirect to index if not host" do
    log_in_as(users(:three))
    set_organization(organizations(:one))

    get edit_organization_member_path(organization_members(:one_two))
    assert_redirected_to organization_members_path
  end

  test "GET delete should redirect to index if not host" do
    log_in_as(users(:three))
    set_organization(organizations(:one))

    get delete_organization_member_path(organization_members(:one_two))
    assert_redirected_to organization_members_path
  end

  # POST/UPDATE/DELETE actions
  # normal testing
  test "POST create if user is host or can invite, input is valid, and reference type is username" do
    log_in_as(users(:one))
    set_organization(organizations(:one))

    user = users(:five)

    assert_difference("OrganizationMember.count", 1) do
      post organization_members_path, params: {
        type: "Username",
        username: user.username,
        can_edit: true,
        can_invite: true
      }
    end

    assert_redirected_to organization_members_path
  end

  test "POST create if user is host or can invite, input is valid, and reference type is email" do
    log_in_as(users(:one))
    set_organization(organizations(:one))

    user = users(:five)

    assert_difference("OrganizationMember.count", 1) do
      post organization_members_path, params: {
        type: "Email",
        email: user.email,
        can_edit: true,
        can_invite: true
      }
    end

    assert_redirected_to organization_members_path
  end

  test "POST create if user is host or can invite, input is valid, and reference type is telephone" do
    log_in_as(users(:one))
    set_organization(organizations(:one))

    user = users(:five)

    assert_difference("OrganizationMember.count", 1) do
      post organization_members_path, params: {
        type: "Telephone",
        telephone: user.telephone,
        can_edit: true,
        can_invite: true
      }
    end

    assert_redirected_to organization_members_path
  end

  test "POST create if user is host, input is valid" do
    log_in_as(users(:one))
    set_organization(organizations(:one))

    user = users(:five)

    assert_difference("OrganizationMember.count", 1) do
      post organization_members_path, params: {
        type: "Username",
        username: user.username,
        can_edit: true,
        can_invite: true
      }
    end

    member = OrganizationMember.find_by(:user_id => user.id)
    assert_equal(member.can_edit, true)
    assert_equal(member.can_invite, true)

    assert_redirected_to organization_members_path
  end

  test "POST create if user can invite and input is valid. Values should be restricted" do
    log_in_as(users(:three))
    set_organization(organizations(:one))

    user = users(:five)

    assert_difference("OrganizationMember.count", 1) do
      post organization_members_path, params: {
        type: "Username",
        username: user.username,
        can_edit: true,
        can_invite: true
      }
    end

    member = OrganizationMember.find_by(:user_id => user.id)
    assert_equal(member.can_edit, false)
    assert_equal(member.can_invite, false)

    assert_redirected_to organization_members_path
  end

  test "PATCH update if user is host and input is valid" do
    log_in_as(users(:one))
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    old_edit = member.can_edit
    old_invite = member.can_invite
    new_edit = !member.can_edit
    new_invite = !member.can_invite

    patch organization_member_path(member.id), params: { organization_member: {
      can_edit: new_edit,
      can_invite:new_invite
      }
    }

    member.reload
    assert_equal(member.can_edit, new_edit)
    assert_equal(member.can_invite, new_invite)

    assert_redirected_to organization_members_path
  end

  test "DELETE destroy if user is host" do
    log_in_as(users(:one))
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    assert_difference("OrganizationMember.count", -1) do
      delete organization_member_path(member.id)
    end

    assert_redirected_to organization_members_path
  end

  # not logged in testing
  test "POST create should redirect to login if not logged in" do
    set_organization(organizations(:one))

    user = users(:five)

    assert_no_difference("OrganizationMember.count") do
      post organization_members_path, params: {
        type: "Username",
        username: user.username,
        can_edit: true,
        can_invite: true
      }
    end

    assert_redirected_to login_path
  end

  test "PATCH update should redirect to login if not logged in" do
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    old_edit = member.can_edit
    old_invite = member.can_invite
    new_edit = !member.can_edit
    new_invite = !member.can_invite

    patch organization_member_path(member.id), params: { organization_member: {
      can_edit: new_edit,
      can_invite:new_invite
      }
    }

    member.reload
    assert_equal(member.can_edit, old_edit)
    assert_equal(member.can_invite, old_invite)

    assert_redirected_to login_path
  end

  test "DELETE destroy should redirect to login if not logged in" do
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    assert_no_difference("OrganizationMember.count") do
      delete organization_member_path(member.id)
    end

    assert_redirected_to login_path
  end

  # not member testing
  test "POST create should redirect to organization index if user is not a member" do
    log_in_as(users(:six))
    set_organization(organizations(:one))

    user = users(:five)

    assert_no_difference("OrganizationMember.count") do
      post organization_members_path, params: {
        type: "Username",
        username: user.username,
        can_edit: true,
        can_invite: true
      }
    end

    assert_redirected_to organizations_path
  end

  test "PATCH update should redirect to organization index if user is not a member" do
    log_in_as(users(:six))
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    old_edit = member.can_edit
    old_invite = member.can_invite
    new_edit = !member.can_edit
    new_invite = !member.can_invite

    patch organization_member_path(member.id), params: { organization_member: {
      can_edit: new_edit,
      can_invite:new_invite
      }
    }

    member.reload
    assert_equal(member.can_edit, old_edit)
    assert_equal(member.can_invite, old_invite)

    assert_redirected_to organizations_path
  end

  test "DELETE destroy should redirect to organization index if user is not a member" do
    log_in_as(users(:six))
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    assert_no_difference("OrganizationMember.count") do
      delete organization_member_path(member.id)
    end

    assert_redirected_to organizations_path
  end

  # not permission testing
  test "POST create should redirect to index if not a host or cannot invite" do
    log_in_as(users(:two))
    set_organization(organizations(:one))

    user = users(:five)

    assert_no_difference("OrganizationMember.count") do
      post organization_members_path, params: {
        type: "Username",
        username: user.username,
        can_edit: true,
        can_invite: true
      }
    end

    assert_redirected_to organization_members_path
  end

  test "PATCH update should redirect to index if not a host" do
    log_in_as(users(:three))
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    old_edit = member.can_edit
    old_invite = member.can_invite
    new_edit = !member.can_edit
    new_invite = !member.can_invite

    patch organization_member_path(member.id), params: { organization_member: {
      can_edit: new_edit,
      can_invite:new_invite
      }
    }

    member.reload
    assert_equal(member.can_edit, old_edit)
    assert_equal(member.can_invite, old_invite)

    assert_redirected_to organization_members_path
  end

  test "DELETE destroy should redirect to index if not a host" do
    log_in_as(users(:three))
    set_organization(organizations(:one))

    member = organization_members(:one_four)

    assert_no_difference("OrganizationMember.count") do
      delete organization_member_path(member.id)
    end

    assert_redirected_to organization_members_path
  end

end
