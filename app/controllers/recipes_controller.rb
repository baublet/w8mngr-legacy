class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy, :update]
  before_action :correct_user, only: [:edit,
                                      :update,
                                      :destroy,
                                      :add_ingredient,
                                      :add_food,
                                      :remove_ingredient
                                    ]

  def index
    @recipes = current_user.recipes.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit
    @newingredient = @recipe.ingredients.build()
  end

  def new
    @recipe = current_user.recipes.build()
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
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

    if !newingredient_params.nil?
      @newingredient = @recipe.ingredients.build(newingredient_params)
      if @newingredient.save
        @recipe.reload
        @newingredient = @recipe.ingredients.build()
      end
    else
      @newingredient = @render.ingredients.build()
    end
    render :edit
  end

  def add_ingredient

  end

  def add_food

  end

  def delete_ingredient
    @ingredient = Ingredient.find_by(id: params[:id])
    @recipe = @ingredient.recipe
    if !@recipe.nil?
      @ingredient.delete
      flash[:success] = "Ingredient removed from the recipe"
      redirect_to edit_recipe_path(@recipe)
    else
      redirect_to recipes_path
    end
  end

  def destroy
    if @recipe.destroy
      flash[:success] = "Recipe deleted"
      redirect_to recipes_path
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

  # Same for the new ingredients
  def newingredient_params
    params.require(:newingredient).permit(:name, :calories, :fat, :carbs, :protein)
  end

end
