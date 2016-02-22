require 'test_helper'

class WeightEntriesControllerTest < ActionController::TestCase
  setup do
    @weight_entry = weight_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weight_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weight_entry" do
    assert_difference('WeightEntry.count') do
      post :create, weight_entry: { day: @weight_entry.day, user_id: @weight_entry.user_id, value: @weight_entry.value }
    end

    assert_redirected_to weight_entry_path(assigns(:weight_entry))
  end

  test "should show weight_entry" do
    get :show, id: @weight_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weight_entry
    assert_response :success
  end

  test "should update weight_entry" do
    patch :update, id: @weight_entry, weight_entry: { day: @weight_entry.day, user_id: @weight_entry.user_id, value: @weight_entry.value }
    assert_redirected_to weight_entry_path(assigns(:weight_entry))
  end

  test "should destroy weight_entry" do
    assert_difference('WeightEntry.count', -1) do
      delete :destroy, id: @weight_entry
    end

    assert_redirected_to weight_entries_path
  end
end
