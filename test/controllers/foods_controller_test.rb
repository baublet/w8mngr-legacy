require 'test_helper'

class FoodsControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(@foods)
  end

  test "should get show" do
    food = foods(:foodone)
    get :show, id: food.id
    assert_response :success
    assert_not_nil assigns(@day)
    assert_not_nil assigns(@food)
  end

  test "should get search" do
    get :search
    assert_response :success
    assert_template "foods/search"
  end

  test "should be able to search own foods" do
    get :search, q: "food"
    assert_response :success
    assert_template "foods/search"
    assert assigns.key?(:searchresults)
    assert assigns.key?(:prev_page)
    assert assigns.key?(:next_page)
    assert assigns.key?(:base_url)
  end

  test "should not be able to search deleted foods" do
    get :search, q: "Another"
    assert_response :success
    assert_template "foods/search"
    assert assigns.key?(:searchresults)
    assert assigns.key?(:prev_page)
    assert assigns.key?(:next_page)
    assert assigns.key?(:base_url)
    assert_equal [], assigns(:searchresults)
  end

  test "should be able to get new" do
    get :new
    assert_response :success
    assert_template "foods/new"
  end

  test "should be able to post new" do
    assert_difference("Food.count") do
      post :create, {
               :food =>
                   {
                    name: "Food name",
                    description: "This is a description"
                  },
               :measurement =>
                   {
                    '0' =>
                      {
                        amount: "1",
                        unit: "unit",
                        calories: 1,
                        fat: 2,
                        carbs: 3,
                        protein: 4
                     }
                  }
               }
     end
     assert_response :success
     assert_template "foods/edit"
     assert_not_nil assigns(:food)
     assert_not_nil assigns(:newmeasurement)
  end

  test "should get edit" do
    food = foods(:foodtwo)
    get :edit, id: food.id
    assert_response :success
    assert_template "foods/edit"
    assert_not_nil assigns(:food)
    assert_not_nil assigns(:newmeasurement)
  end

  test "should not get edit another user's food" do
    food = foods(:foodone)
    get :edit, id: food.id
    assert_redirected_to root_url
  end

  # We aren't testing the update function here because we do that in
  # the integration test; and because controller-wise, if the user
  # can't edit an entry not their own, they can't update it, either

  test "should be able to delete own food" do
    food = foods(:foodtwo)
    assert_difference("Food.count", -1) do
      get :destroy, id: food.id
    end
    assert_response :redirect
    assert_redirected_to foods_url
  end

  test "should not be able to delete another user's food" do
    food = foods(:foodone)
    get :destroy, id: food.id
    assert_redirected_to root_url
  end
end
