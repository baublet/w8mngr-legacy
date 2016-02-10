class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]
  
  before_action :logged_in_user, only: [:new, :create, :destroy, :update]
  before_action :correct_user, only: [:update, :destroy]

  # GET /foods
  def index
    @foods = Food.all
  end

  # GET /foods/1
  def show
  end

  # GET /foods/new
  def new
    @food = Food.new
  end

  # GET /foods/1/edit
  def edit
  end

  # POST /foods
  def create
    @food = Food.new(food_params)

    if @food.save
      redirect_to @food, notice: 'Food was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /foods/1
  def update
    if @food.update(food_params)
      redirect_to @food, notice: 'Food was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /foods/1
  def destroy
    @food.destroy
    redirect_to foods_url, notice: 'Food was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def food_params
      params.require(:food).permit(:name, :description, :food_type, :calories, :fat, :carbs, :protein, :amount, :measurement, :serving_size)
    end
    
    def correct_user
		@food = current_user.foods.find_by(id: params[:id])
		redirect_to root_url if @food.nil?
	end
end
