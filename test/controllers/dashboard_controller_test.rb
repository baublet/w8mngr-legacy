require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  test "should redirect if not logged in" do
    get :index
    assert_response :redirect
    get :index, format: "json"
    assert_response :redirect
  end

  test "should get html" do
    log_in
    get :index
    assert_response :success
    assert_template "index"
  end

  test "should get json" do
    log_in
    get :index, format: "json"
    assert_response :success
    dashboard_info = JSON.parse(@response.body)
    ["tdee", "atdee", "first_weight", "last_weight", "weight_difference", "first_weight_date",
     "last_weight_date", "first_last_difference", "min_weight", "fat", "carbs", "protein",
     "week_averages", "week_calories", "week_weights"].each do |var|
      assert_not (defined? dashboard_info[var]).nil?
    end
  end

end