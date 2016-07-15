require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  test "should redirect if not logged in" do
    [:index, :new, :create].each do |route|
      get route
      assert_response :redirect
    end
    # Need to pass in an ID for these to work, hence the
    # different method for testing
    id = "gobble"
    ['get :edit, id: id',
     'patch :update, id: id',
     'put :update, id: id',
     'delete :destroy, id: id'
    ].each do |route|
      eval(route)
      assert_response :redirect
    end
  end

  test "should render OK if logged in" do
    log_in
    get :index
    assert_response :success
    assert assigns.key?(:activities)
    assert_template "index"
    assert_template "_activity_short"
  end

  test "should get show" do
    log_in
    activity = @user.activities.first
    get :show, id: activity.id
    assert_response :success
    assert assigns.key?(:activity)
    assert_template "show"
  end

  test "should get new" do
    log_in
    get :new
    assert_response :success
    assert assigns.key?(:activity)
    assert_template "new"
  end

  test "should get edit" do
    log_in
    get :edit, id: @user.activities.first.id
    assert_response :success
    assert_template "edit"
  end

  test "should create" do
    log_in
    put :create, activity: { name: "aaaa", description: "adfasdfasdf" }
    assert_response :redirect
  end

  test "should update" do
    log_in
    activity = @user.activities.first
    put :update, id: activity.id, activity: { name: "bbbb" }
    assert_response :success
    assert_template "edit"
    activity.reload
    assert_equal "bbbb", activity.name
  end

  test "should destroy" do
    log_in
    activity = @user.activities.first
    delete :destroy, id: activity.id
    assert_response :redirect
    assert_redirected_to activities_path
  end

end