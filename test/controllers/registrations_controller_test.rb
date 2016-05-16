require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should post create" do
    post :create, user: {
      email: "thisisatest@w8mngr.com",
      password: "password",
      password_confirmation: "password"
    }
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should post tdee" do
    post :calculate, info: {
      height: "6'1\"",
      weight: "199lbs",
      birthday: "05-01-1985",
      sex: "m",
      activity: 3
    }
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should post target" do
    post :target, target: {
      calories: "2200"
    }
    assert_response :redirect
  end
end