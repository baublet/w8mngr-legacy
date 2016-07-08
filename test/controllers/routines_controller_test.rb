require 'test_helper'

class RoutinesControllerTest < ActionController::TestCase

  test "should redirect if not logged in" do
    [ "get :index",
      "get :edit, id: 10",
      "post :create",
      "delete :destroy, id: 10",
    "patch :update, id: 10"].each do |route|
      eval(route)
      assert_response :redirect
    end
  end

  test "should get index" do
    log_in
    get :index
    assert_response :success
    assert_template "index"
  end

  test "should get show" do
    log_in
    get :show, id: @user.routines.first.id
    assert_response :success
    assert_template "show"
  end

  test "should get edit" do
    log_in
    get :edit, id: @user.routines.first.id
    assert_response :success
    assert_template "edit"
  end

  test "should patch update" do
    log_in
    patch :update, id: @user.routines.first.id, routine: { name: "new name", description: "new description" }
    assert_response :redirect
    assert_redirected_to edit_routine_path @user.routines.first
  end

  test "should put new" do
    log_in
    put :create, user_id: @user.id, routine: { name: "new thing name", description: "new thing description" }
    assert_response :redirect
    assert_redirected_to edit_routine_path @user.routines.last
  end

  test "should delete destroy" do
    log_in
    delete :destroy, id: @user.routines.first.id
    assert_response :redirect
    assert_redirected_to routines_path
  end

end