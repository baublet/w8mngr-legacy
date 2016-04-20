require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
    assert_template "new"
  end

  test "should get destroy" do
    # First log in
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
    # Then log out
    get :destroy
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should post create (login)" do
    @user = users(:test)
    post :create, session: { email: @user.email, password: "password" }
    assert_response :redirect
    assert_redirected_to @user
  end

  test "should not log in if not a real user"  do
    post :create, session: { email: "123412341234wdjknsdjfvn@sdnfkwjn3kjnfe.com", password: "password" }
    assert_response :success
    assert_template "new"
  end

  test "should login to an appropriate URL" do
    @user = users(:test)
    session[:forwarding_url] = foodlog_path
    post :create, session: { email: @user.email, password: "password" }
    assert_response :redirect
    assert_redirected_to foodlog_path
  end

end
