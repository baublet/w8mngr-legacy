class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy, :update]
  before_action :correct_user, only: [:edit, :update, :destroy, :add_ingredient, :add_food]

  def index
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit
    @newingredient = @recipe.ingredients.build()
  end

  def new
  end

  def create
    if @recipe.save
      flash.now[:success] = "Your recipe was successfully created"
      @newingredient = @recipe.ingredients.build()
      render :edit
    else
      @newrecipe = @recipe
      render :new
    end
  end

  def update
    if @recipe.update(recipe_params)
      flash.now[:success] = "Recipe successfully updated"
    else
      flash.now[:error] = "Error updating the recipe"
    end
    @newingredient = @render.ingredients.build()
    render :edit
  end

  def add_ingredient

  end

  def add_food

  end

  def destroy
    if @recipe.destroy
      flash.now[:success] = "Recipe deleted"
      render :index
    else
      flash.now[:error] = "Unknown error deleting recipe"
      render :edit
    end
  end

  private

  def correct_user
    @recipe = current_user.recipes.find_by(id: params[:id])
    redirect_to root_url if @recipe.nil?
  end

  # Only allow a trusted parameter "white list" through.
  def recipe_params
    params.require(:recipe).permit(:name, :description, :instructions)
  end

end
