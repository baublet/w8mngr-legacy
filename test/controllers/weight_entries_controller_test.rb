require 'test_helper'

class WeightEntriesControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  test "should get index" do
    get :index
    assert_response :success
    should_get_index
  end

  test "should post create" do
    weight_entry = {
      day: 20000101,
      value: 199
    }
    post :create, { weight_entry: weight_entry }
    assert_response :redirect
    assert_redirected_to weight_log_day_path(weight_entry[:day])
  end

  test "should post delete" do
    weight_entry = @user.weightentries.first
    delete :destroy, { id: weight_entry.id }
    assert_response :redirect
    assert_redirected_to weight_log_day_path(weight_entry.day)
  end

  private

  def should_get_index
    assert assigns.key?(:weightentries)
    assert assigns.key?(:weight_average)
    assert assigns.key?(:newweightentry)
    assert_template "index"
  end

end
