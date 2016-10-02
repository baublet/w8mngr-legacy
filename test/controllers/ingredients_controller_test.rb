require 'test_helper'

class IngredientsControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
    @recipe = recipes(:three)
  end

  test "should post create" do
    post :create, {
      recipe_id: @recipe.id,
      ingredient: {
        name: "Here's an ingredient",
        calories: 100,
        fat: 200,
        carbs: 300,
        protein: 400
      }
    }
    assert_response :redirect
    assert_equal "Added ingredient to recipe.", flash[:success]
  end

  test "should post create_from_food" do
    measurement = measurements(:measurementone)
    post :create_from_food, {
      recipe_id: @recipe.id,
      measurement_id: measurement.id,
      amount: 3
    }
    assert_response :redirect
    assert_equal "Food successfully added to recipe", flash[:success]
  end

  test "should get destroy" do
    recipe = recipes(:recipefour)
    ingredient = ingredients(:ingredienttwo)
    get :destroy, {
      recipe_id: recipe.id,
      id: ingredient.id
    }
  end


end