require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template "new"
  end

  test "should get create" do
    get :create, password_reset: { email: @user.email }
    assert_response :redirect
  end

  test "should not get create on unknown email" do
    get :create, password_reset: { email: "asdfasdf12342134" + @user.email }
    assert_response :success
    assert_template "new"
  end

  test "should create new reset digest" do
    @user.create_reset_digest
    original_token = @user.reset_token
    post :create, password_reset: { email: @user.email }
    assert_response :redirect
    assert_equal "Email sent with password reset instructions.", flash[:success]
  end

  test "should not create new digest if the email is invalid" do
    post :create, password_reset: { email: "asdf14123" + @user.email }
    assert_response :success
    assert_template "new"
  end

  test "should get edit" do
    @user.create_reset_digest
    get :edit, id: @user.reset_token, email: @user.email
    assert_response :success
    assert_template "edit"
  end

  test "should be able to update password" do
    @user.create_reset_digest
    post :update, id: @user.reset_token,
                  email: @user.email,
                  user: { password: "thisisanewpassword!" }
    assert_response :redirect
    assert_redirected_to @user
  end

  test "should not be able to update with no reset digest" do
    @user.reset_token = ""
    @user.reset_sent_at = 0
    post :update, id: "this isn't a real digest!", user: { password: "thisisanewpassword" }
    assert_response :redirect
    assert_redirected_to root_url
  end
end
