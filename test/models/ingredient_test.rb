require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
      @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
      # This is require for us to work with any food entries since they belong to valid users
      @user.save
      @recipe = @user.recipes.build(
        name: "This is a valid food name",
        description: "This is a description",
        instructions: "And here are my instructions"
      )
      @measurement = measurements(:measurementone)
  end

  test "user can create a valid custom ingredient" do
    ingredient = @recipe.ingredients.build(
      measurement_id: @measurement.id
    )
    assert ingredient.valid?

    ingredient = @recipe.ingredients.build(
      measurement_id: nil,
      name: "My custom ingredient",
      calories: 25,
      fat: 10,
      carbs: 12,
      protein: 3
    )
    assert ingredient.valid?
  end

  test "user cannot save invalid ingredients" do
    ingredient = Ingredient.new(
      measurement_id: nil,
      name: nil,
      calories: nil,
      fat: nil,
      carbs: nil,
      protein: nil
    )
    assert_not ingredient.valid?
    ingredient.measurement_id = 123
    assert_not ingredient.valid?
    ingredient.measurement_id = nil
    assert_not ingredient.valid?
    ingredient.name = "My custom ingredient"
    assert_not ingredient.valid?
    ingredient.calories = 25
    assert_not ingredient.valid?
    ingredient.fat = 10
    assert_not ingredient.valid?
    ingredient.carbs = 12
    assert_not ingredient.valid?
    ingredient.protein = 3
    assert ingredient.valid?
    [-1, "twelve", "fart"].each do |value|
      ingredient.calories = value
      assert_not ingredient.valid?
    end
  end
end
