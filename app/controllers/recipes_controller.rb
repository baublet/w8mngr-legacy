class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy, :update]
  before_action :correct_user, only: [:edit, :update, :destroy, :add_ingredient, :add_food]

  def index

  end

  def show

  end

  def edit

  end

  def new

  end

  def create

  end

  def update

  end

  def add_ingredient

  end

  def add_food

  end

  def destroy

  end

  private

  def correct_user
    @recipe = current_user.recipes.find_by(id: params[:id])
    redirect_to root_url if @recipe.nil?
  end

end
