require 'test_helper'

class ActivityEntriesControllerTest < ActionController::TestCase

  test "should redirect if not logged in" do
    get :index, day: 20010101, activity_id: Activity.first.id
    assert_response :redirect
    get :index, activity_id: Activity.first.id
    assert_response :redirect
    put :create, activity_id: Activity.first.id
    assert_response :redirect
    delete :destroy, activity_id: Activity.first.id, id: "notarealid"
    assert_response :redirect
  end

  test "should throw a 404 if they don't pass a valid activity id" do
    log_in
    get :index, activity_id: "test"
    assert_response :missing
  end

  test "should load index properly" do
    log_in
    get :index, activity_id: Activity.first.id
    assert_response :success
    assert_template "index"
    assert assigns.key?(:activity)
    assert assigns.key?(:activityentries)
  end

  test "should create properly" do
    log_in
    put :create, activity_id: Activity.first.id, day: 20010101, work: 10
    assert_response :success
    assert_template "index"
    assert assigns.key?(:activity)
    assert assigns.key?(:activityentries)
  end

  test "should update properly" do
    log_in
    patch :update, activity_id: Activity.first.id, id: ActivityEntry.first.id, work: 20
    assert assigns.key?(:activity)
    assert assigns.key?(:activityentries)
  end

  test "should destroy properly" do
    log_in
    activity = @user.activity_entries.first
    delete :destroy, activity_id: activity.activity.id, id: activity.id
    assert_response :success
    assert assigns.key?(:activity)
    assert assigns.key?(:activityentries)

  end

end