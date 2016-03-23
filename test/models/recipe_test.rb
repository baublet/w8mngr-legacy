require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
      @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
      # This is require for us to work with any food entries since they belong to valid users
      @user.save
      @recipe = @user.recipes.build(
        name: "This is a valid food name",
        description: "This is a description",
        instructions: "And here are my instructions",
        servings: 1
      )
      assert @recipe.valid?
      assert @recipe.save
  end

  test "user can save a valid recipe" do
    assert_equal 1, @user.recipes.all.count

    for i in 1...50 do
      @recipe.servings = i
      assert @recipe.valid?, "Servings couldn't be saved at " + i.to_s
    end
  end

  test "user cannot create invalid recipes" do
    @recipe.name = ""
    assert_not @recipe.valid?
    @recipe.name = "a" * 256
    assert_not @recipe.valid?
    @recipe.name = "a" * 7
    assert_not @recipe.valid?
    @recipe.name = "a" * 8
    assert @recipe.valid?

    @recipe.servings = -1
    assert_not @recipe.valid?
    @recipe.servings = 51
    assert_not @recipe.valid?

    @recipe.description = nil
    assert_not @recipe.valid?
  end

  test "user can attach recipes to ingredients" do
    @recipe = @user.recipes.first
    ingredient = @recipe.ingredients.build(
      measurement_id: nil,
      name: "My custom ingredient",
      calories: 25,
      fat: 10,
      carbs: 12,
      protein: 3)
    assert ingredient.valid?
    assert ingredient.save
    assert_equal 25, @recipe.calories
    assert_equal 10, @recipe.fat
    assert_equal 12, @recipe.carbs
    assert_equal 3, @recipe.protein
    # Make sure this also works for measurement IDs
    ingredient = @recipe.ingredients.build(
      measurement_id: measurements(:measurementone).id
    )
    assert ingredient.valid?
    assert ingredient.save
    @recipe.reload
    assert_equal 26, @recipe.calories
    assert_equal 12, @recipe.fat
    assert_equal 15, @recipe.carbs
    assert_equal 7, @recipe.protein
  end
end
