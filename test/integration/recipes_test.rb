require 'test_helper'

class FoodsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  # Happy path first
  test "user can create a recipe" do
    create_valid_recipe
  end

  test "user can delete a recipe"  do
    create_valid_recipe
    assert_response_contains delete_recipe_path(@recipe.id)
    assert_difference "Recipe.count", -1 do
    	get delete_recipe_path(@recipe.id)
    end
    follow_redirect!
    assert_template "recipes/index"
  end

  test "user can add and remove a custom ingredient from a recipe" do
    new_recipe = {
      name: Faker::Lorem.sentence(12),
      description: Faker::Lorem.sentence(55),
      instructions: Faker::Lorem.sentence(255),
      servings: Faker::Number.between(1, 10)
    }
    new_ingredient = {
    	name: Faker::Lorem.sentence(12),
      calories: Faker::Number.between(1, 200),
      fat: Faker::Number.between(1, 200),
      carbs: Faker::Number.between(1, 200),
      protein: Faker::Number.between(1, 200),
    }
    create_valid_recipe new_recipe
    assert_template "recipes/edit"

		assert_difference "Ingredient.count" do
	    patch recipe_path(@recipe), {
	            :recipe => new_recipe,
	            :newingredient => new_ingredient
			}
		end

		assert_response :redirect
    follow_redirect!
    assert_template "recipes/edit"

    assert_response_contains new_recipe
    assert_response_contains new_ingredient

    last_ingredient = Ingredient.last

    assert_response_contains delete_recipe_ingredient_path(last_ingredient.recipe, last_ingredient)

    assert_difference "Ingredient.count", -1 do
    	get delete_recipe_ingredient_path(last_ingredient.recipe, last_ingredient)
    end
  end

  private

  def create_valid_recipe recipe = nil
  	recipe = {
  		name: Faker::Lorem.sentence(3),
  		description: Faker::Lorem.sentence(55)
  	} if recipe.nil?
    get new_recipe_path
    assert_template "recipes/new"
    assert_difference "Recipe.count" do
      post recipes_path, {
               :recipe =>
                   {
                    name: recipe[:name],
                    description: recipe[:description]
                  }
               }
    end
    assert_response :redirect
    follow_redirect!
    assert_template "recipes/edit"
    assert_response_contains recipe[:name]
    assert_response_contains recipe[:description]
    @recipe = @user.recipes.last
    assert_not_nil @recipe
  end

end
