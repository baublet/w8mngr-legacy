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
    html_renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      no_images: true,
      no_links: true,
      no_styles: true
      )
    markdown = Redcarpet::Markdown.new(html_renderer, extensions = {})
    @preparation_instructions = markdown.render(@recipe.instructions)
  end

  def edit
    @newingredient = Ingredient.new(recipe_id: @recipe.id)
  end

  def new
    @recipe = current_user.recipes.build()
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      flash[:success] = "Your recipe was successfully created"
      redirect_to edit_recipe_path(@recipe)
    else
      @newrecipe = @recipe
      render :new
    end
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe successfully updated"
    else
      flash[:error] = "Error updating the recipe"
    end

    # Add the new ingredient if the user passed anything
    new_ingredient_save_attempt = false
    if new_ingredient_info_passed?
      new_ingredient_save_attempt = true
      @newingredient = Ingredient.new(new_ingredient_params)
      @newingredient.recipe_id = @recipe.id
    end

    # This block allows failed attempts at adding ingredients to fail explicitly
    if new_ingredient_save_attempt
      if !@newingredient.save
        render :edit
      else
        redirect_to edit_recipe_path(@recipe)
      end
    else
      redirect_to edit_recipe_path(@recipe)
    end
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
    params.require(:recipe).permit(:name, :description, :instructions, :servings)
  end

  # Same for the new ingredients
  def new_ingredient_params
    params.require(:newingredient).permit(:name, :calories, :fat, :carbs, :protein)
  end

  # Returns true if the user passed any new ingredient information
  def new_ingredient_info_passed?
    passed = false
    new_ingredient_params.each do |key, value|
      passed = true if !value.blank?
    end
    passed
  end

end
