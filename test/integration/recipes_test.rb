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
    delete_button = css_select ".recipe-form .delete-btn"
    get delete_button[0]["href"]
		follow_redirect!
    assert_template "recipes/index"
  end

  test "user can add and remove a custom ingredient from a recipe" do
    create_valid_recipe
    patch recipe_path(@recipe), {
						:recipe =>
						{
							name: "My recipe Name",
							description: "The description goes here!",
							instructions: "And then, there are the instructions...",
							servings: 1
						},
						:newingredient =>
						 		{
									name: "Custom ingredient name",
									calories: 123,
                  fat: 234,
                  carbs: 345,
                  protein: 456
								}
						 }
		follow_redirect!
    assert_template "recipes/edit"
		assert_select ".recipe-form .ingredient"
    ingredient_delete = css_select ".recipe-form .ingredient .delete-btn"
    get ingredient_delete[0]["href"]
		follow_redirect!
    assert_template "recipes/edit"
    assert_select ".recipe-form .ingredient", count: 0
  end

  private

  def create_valid_recipe
    get new_recipe_path
		assert_template "recipes/new"
		post recipes_path, {
						 :recipe =>
						 		{
									name: "Recipe name",
									description: "This is a description"
								}
						 }
		follow_redirect!
		assert_template "recipes/edit"
		assert_select ".error-explanation", false
    @recipe = @user.recipes.last
		assert_not_nil @recipe
  end

end
