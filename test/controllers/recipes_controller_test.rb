require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  test "should get index" do
    get :index
    assert_response :success
    assert assigns.key?(:recipes)
    assert_template :index
  end

  test "should get show" do
    recipe = @user.recipes.first
    get :show, { id: recipe.id }
    assert_response :success
    assert assigns.key?(:recipe)
    assert assigns.key?(:preparation_instructions)
    assert_template :show
  end

  test "should get edit" do
    recipe = @user.recipes.first
    get :edit, { id: recipe.id }
    assert_response :success
    assert assigns.key?(:recipe)
    assert assigns.key?(:newingredient)
    assert_template :edit
  end

  test "should get new" do
    get :new
    assert_response :success
    assert assigns.key?(:recipe)
    assert_template :new
  end

  test "should post create" do
    recipe = {
      name: "Test recipe all the way here",
      description: "Here's a test new recipe's description. Ain't it grand?",
      servings: 2,
      instructions: "And some cool instructions here."
    }
    post :create, { recipe: recipe }
    assert_response :redirect
  end

  test "should post update" do
    recipe = @user.recipes.first
    post :update, {
      id: recipe.id,
      recipe: {
        name: "Here's a recipe name for you",
        description: "Some new description here that has to be sufficiently long."
      },
      newingredient: {
       name: "My ingredient",
       calories: 100,
       fat: 200,
       carbs: 300,
       protein: 400
      }
    }
    assert_response :redirect
    assert_equal "Recipe successfully updated", flash[:success]
  end

  test "should get delete" do
    recipe = @user.recipes.first
    get :destroy, { id: recipe.id }
    assert_response :redirect
    assert_equal "Recipe deleted", flash[:success]
  end

end