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
end
