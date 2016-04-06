require 'test_helper'

class FoodEntriesControllerTest < ActionController::TestCase
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
    assert_difference("FoodEntry.count") do
      post :create, food_entry: {  day: 20000101,
                       description: "Food entry",
                       calories: 200,
                       fat: 10,
                       carbs: 45,
                       protein: 10
                   }
      assert_response :success
    end
    should_get_index
  end

  test "should post update" do
    @foodentry = food_entries(:test2)
    post :update, id: @foodentry.id, food_entry: { calories: 333 }
    assert_response :success
    should_get_index
  end

  test "should not be able to update entry that is not ones own" do
    @foodentry = food_entries(:test)
    post :update, id: @foodentry.id, food_entry: { calories: 333 }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should delete" do
    @foodentry = food_entries(:test2)
    get :destroy, id: @foodentry.id
    assert_response :success
    should_get_index
  end

  test "should not be able to delete entry that is not ones own" do
    @foodentry = food_entries(:test)
    get :destroy, id: @foodentry.id
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should add food to log" do
    @measurement = measurements(:measurementtwo)
    assert_difference("FoodEntry.count") do
      get :add_food, day: "20000101", measurement_id: @measurement.id
    end
    assert_response :redirect
    assert_redirected_to food_log_day_path("20000101")
  end

  # This function ensures that the index is fully displayed, as is the case
  # whenever any action is take on the food log
  def should_get_index
    assert_not_nil assigns(@foodentries)
    assert_not_nil assigns(@total)
    assert_not_nil assigns(@newfoodentry)
  end

end
