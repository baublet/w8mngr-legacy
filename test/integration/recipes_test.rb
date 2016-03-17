require 'test_helper'

class FoodsTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:test)
		log_in_as(@user)
		assert logged_in?
    @recipe_id = 0
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

  test "user can add and remove a custom ingredient to a recipe" do
    create_valid_recipe
    post recipes_path, {
						:recipe =>
						{
							name: "My recipe Name",
							description: "The description goes here!",
							instructions: "And then, there are the instructions..."
						},
						:newingredient =>
						 		{
									name: "Custom ingredient name",
									calories: 123,
                  fat: 234,
                  carbs: 345,
                  protein: 456,
                  recipe_id: @recipe_id
								}
						 }
    assert_template "recipes/edit"
    ingredient_delete = css_select ".recipe-form .ingredient .delete-btn"
    get ingredient_delete[0].href
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
		assert_template "recipes/edit"
		assert_select ".error-explanation", false
    hidden_fields = css_select ".recipe-form input[type=hidden]"
    @recipe_id = hidden_fields[2]["value"].to_i
  end

end
