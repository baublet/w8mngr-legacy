require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should get show" do
    log_in
    get :show, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should post create" do
    post :create, user: {
      email: "thisisatest@w8mngr.com",
      password: "password",
      password_confirmation: "password"
    }
    assert_response :redirect
  end

  test "should get edit" do
    log_in
    get :edit, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_template "edit"
  end

  test "should post update" do
    log_in
    post :update, id: @user.id
    assert_response :success
    assert_template "edit"
  end

  private

  def log_in
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

end
