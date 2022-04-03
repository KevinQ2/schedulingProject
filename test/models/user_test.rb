require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      username: "user1",
      password: "password1",
      first_name: "user",
      last_name: "one",
      email: "user1@hotmail.com",
      telephone: "0123456789"
    )

    @user2 = User.new(
      username: "user2",
      password: "password2",
      first_name: "user",
      last_name: "two",
      email: "user2@hotmail.com",
      telephone: "0123456781"
    )
  end

  test "@user should be valid" do
    assert @user.valid?
  end

  test "@user2 should be valid" do
    assert @user.valid?
  end

  test "username should automatically be undercase" do
    @user.username = "HELLO"
    @user.save
    assert_equal("hello", @user.username)
  end

  test "username should not be blank" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.save
    @user2.username = @user.username
    assert_not @user2.valid?
  end

  test "password should be automatically encrypted" do
    assert_not_equal(@user.password, @user.password_digest)
  end

  test "password_confirmation should be equal to password" do
    @user.password = "hello"
    @user.password_confirmation = "Hello"
    assert_not @user.valid?
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = ""
    assert_not @user.valid?
  end

  test "password should not be less than 4 characters" do
    @user.password = @user.password_confirmation = "a" * 3
    assert_not @user.valid?
  end

  test "password can be 4 characters" do
    @user.password = @user.password_confirmation = "a" * 4
    assert @user.valid?
  end

  test "password should not be longer than 30 characters" do
    @user.password = @user.password_confirmation = "a" * 31
    assert_not @user.valid?
  end

  test "password can be 30 characters" do
    @user.password = @user.password_confirmation = "a" * 30
    assert @user.valid?
  end

  test "first_name should not be blank" do
    @user.first_name = ""
    assert_not @user.valid?
  end

  test "first_name should not be less than 2 characters" do
    @user.first_name = "a"
    assert_not @user.valid?
  end

  test "first_name can be 2 characters" do
    @user.first_name = "a" * 2
    assert @user.valid?
  end

  test "first_name should not be longer than 20 characters" do
    @user.first_name = "a" * 21
    assert_not @user.valid?
  end

  test "first_name can be 20 characters" do
    @user.first_name = "a" * 20
    assert @user.valid?
  end

  test "last_name should not be blank" do
    @user.last_name = ""
    assert_not @user.valid?
  end

  test "last_name should not be less than 2 characters" do
    @user.last_name = "a"
    assert_not @user.valid?
  end

  test "last_name can be 2 characters" do
    @user.last_name = "a" * 2
    assert @user.valid?
  end

  test "last_name should not be longer than 20 characters" do
    @user.last_name = "a" * 21
    assert_not @user.valid?
  end

  test "last_name can be 20 characters" do
    @user.last_name = "a" * 20
    assert @user.valid?
  end

  test "email should automatically be undercase" do
    @user.email = "HELLO@gmail.com"
    @user.save
    assert_equal("hello@gmail.com", @user.email)
  end

  test "email can be blank" do
    @user.email = ""
    assert @user.valid?
  end

  test "email should be unique" do
    @user.save
    @user2.email = @user.email
    assert_not @user2.valid?
  end

  test "email should follow the correct regex" do
    @user.email = "myemail"
    assert_not @user.valid?
  end

  test "telephone can be blank" do
    @user.telephone = ""
    assert @user.valid?
  end

  test "telephone should be unique" do
    @user.save
    @user2.telephone = @user.telephone
    assert_not @user2.valid?
  end

  test "telephone should only have nummbers" do
    @user.telephone = "hello"
    assert_not @user.valid?
  end
end
