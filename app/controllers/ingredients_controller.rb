class IngredientsController < ApplicationController
  before_action :correct_user, only: [:update, :destroy]

  def create
    @recipe = current_user.recipes.find_by(id: params[:recipe_id])
    redirect_to root_url if @recipe.nil?
    @ingredient = @recipe.ingredients.build(ingredient_params)
    if @ingredient.save
      flash[:success] = "Added ingredient to recipe"
      redirect_to edit_recipe_path(@recipe)
    else
      @newingredient = @ingredient
      render "recipe/edit"
    end
  end

  def create_from_food
    @recipe = current_user.recipes.find_by(id: params[:recipe_id])
    redirect_to root_url if @recipe.nil?
    @measurement = Measurement.find_by(id: params[:measurement_id])
    redirect_to root_url if @measurement.nil?

    @recipe.ingredients.build(measurement_id: @measurement.id)
    if @recipe.save
      flash[:success] = "Food successfully added to recipe"
    else
      flash[:error] = "Unknown error adding food to recipe"
    end

    redirect_to edit_recipe_path(@recipe)
  end

  def update
  end

  def destroy
    @ingredient.destroy
    flash[:success] = "Ingredient removed from recipe"
    redirect_to edit_recipe_path(@recipe)
  end

  private

  def correct_user
    @recipe = current_user.recipes.find_by(id: params[:recipe_id])
    redirect_to root_url if @recipe.nil?
    @ingredient = @recipe.ingredients.find_by(id: params[:id])
    redirect_to root_url if @ingredient.nil?
  end

  # Only allow a trusted parameter "white list" through.
  def ingredient_params
    params.require(:ingredient).permit(:name, :calories, :fat, :carbs, :protein)
  end

end
