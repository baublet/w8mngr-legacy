require 'test_helper'

class FaturdayControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
    @user.preferences["faturday_enabled"] = true
    @user.preferences["faturday_calories"] = 5
    @user.preferences["faturday_fat"] = 4
    @user.preferences["faturday_carbs"] = 3
    @user.preferences["faturday_protein"] = 2
    @user.save
  end

  test "should get create" do
    get :create
    assert_response :redirect
  end

  test "should create faturday if no other param passed" do
    assert_difference("FoodEntry.count") do
      get :create
    end
    assert_response :redirect
    assert_redirected_to food_log_day_path Time.current.strftime('%Y%m%d')
  end

  test "should create faturday for the day passed" do
    assert_difference("FoodEntry.count") do
      get :create, day: 20000101
    end
    assert_response :redirect
    assert_redirected_to food_log_day_path 20000101
  end

end
