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
      assert @recipe.valid?
      assert @recipe.save
      @measurement = measurements(:measurementone)
      assert @measurement.valid?
      assert @measurement.save
  end

  test "user can create a valid custom ingredient" do
    ingredient = @recipe.ingredients.build(
      amount: "1",
      measurement_id: @measurement.id
    )
    assert ingredient.valid?

    ingredient = @recipe.ingredients.build(
      amount: "1",
      measurement_id: nil,
      name: "My custom ingredient",
      calories: 25,
      fat: 10,
      carbs: 12,
      protein: 3
    )
    assert ingredient.valid?
  end

  test "ingredients automatically load ingredient measurement links" do
    ingredient = @recipe.ingredients.build(
      amount: "1",
      measurement_id: @measurement.id
    )
    assert ingredient.valid?
    assert ingredient.save
    assert_equal ingredient.measurement_id, @measurement.id
    ingredient.reload
    assert_equal "1 unit, A food name", ingredient.name
    assert_equal 1, ingredient.calories
    assert_equal 2, ingredient.fat
    assert_equal 3, ingredient.carbs
    assert_equal 4, ingredient.protein
  end

  test "user cannot create invalid ingredients" do
    ingredient = @recipe.ingredients.build(
      amount: nil,
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
    # We let users now enter ingredients without this to take into account things
    # like spices, salt, pepper, and things without calories/macros
    # ingredient.name = "My custom ingredient"
    # assert_not ingredient.valid?
    # ingredient.calories = 25
    # assert_not ingredient.valid?
    # ingredient.fat = 10
    # assert_not ingredient.valid?
    # ingredient.carbs = 12
    # assert_not ingredient.valid?
    # ingredient.protein = 3
    assert ingredient.valid?
    [-1, "twelve", "what?"].each do |value|
      ingredient.calories = value
      assert_not ingredient.valid?
      ingredient.fat = value
      assert_not ingredient.valid?
      ingredient.carbs = value
      assert_not ingredient.valid?
      ingredient.protein = value
      assert_not ingredient.valid?
    end
  end
end
