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

  test "should be able to get new" do
    get :new
    assert_response :success
    assert_template "foods/new"
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

  test "should be able to delete own food" do
    food = foods(:foodtwo)
    get :destroy, id: food.id
    assert_response :redirect
    assert_redirected_to foods_url
  end

  test "should not be able to delete another user's food" do
    food = foods(:foodone)
    get :destroy, id: food.id
    assert_redirected_to root_url
  end
end
