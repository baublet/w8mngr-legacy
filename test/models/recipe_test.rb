require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
      @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
      # This is require for us to work with any food entries since they belong to valid users
      @user.save
      @recipe = @user.recipes.build(
        name: "This is a valid food name",
        description: "This is a description",
        instructions: "And here are my instructions"
      )
  end

  test "user can create a valid recipe" do
    assert @recipe.valid?
    @recipe.save
    assert_equal 1, @user.recipes.all.count
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

    @recipe.description = nil
    assert_not @recipe.valid?
  end
end
