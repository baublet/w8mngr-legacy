class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  before_action :logged_in_user, only: [:new, :create, :destroy, :update]
  before_action :correct_user, only: [:update, :destroy]

  # GET /foods
  def index
    @foods = current_user.foods.all
  end

  # GET /foods/1
  def show
  end

  # GET /foods/new
  def new
    @food = current_user.foods.new
    @newmeasurement = Measurement.new
  end

  # GET /foods/1/edit
  def edit
    @food = current_user.foods.find(params[:id])
    @newmeasurement = Measurement.new
  end

  # POST /foods
  def create
    @food = current_user.foods.new(food_params)
    @measurement = @food.measurements.new(measurement_params(params[:measurement]['0']))
    
    if @food.save
        @newmeasurement = Measurement.new
        render :edit
    else
        @food.measurements.clear
        @newmeasurement = Measurement.new(measurement_params(params[:measurement]['0']))
        render :new
    end
  end

  # PATCH/PUT /foods/1
    def update
        @newmeasurement = Measurement.new
        food_update_error = ''
        if @food.update(food_params)
            
            # Update existing measurements
            @food.measurements.each do |measurement|
                if params[:measurement][measurement.id.to_s].present?
                    if !measurement.update( measurement_params(params[:measurement][measurement.id.to_s]) )
                        food_update_error = "One or more of your measurements failed to save."
                    end
                end
            end
            
            # Add a new measurement, if the form is filled in
            new_measurement_params = measurement_params(params[:measurement]['0'])
            if  !new_measurement_params[:amount].blank? ||
                !new_measurement_params[:unit].blank? ||
                !new_measurement_params[:calories].blank? ||
                !new_measurement_params[:fat].blank? ||
                !new_measurement_params[:carbs].blank? ||
                !new_measurement_params[:protein].blank?
                
                @newmeasurement = @food.measurements.new(new_measurement_params)
                
                if !@newmeasurement.save
                    food_update_error = "One or more of your measurements failed to save."
                else
                    @newmeasurement = Measurement.new
                end
                
            end
            
        else
            food_update_error = "Your food entry failed to save."
        end
        
        if food_update_error.blank?
            flash.now[:success] = "Entry successfully saved!"
        else
            flash.now[:error] = food_update_error
        end
        
        render :edit
    end

  # DELETE /foods/1
  def destroy
    @food.destroy
    redirect_to foods_url, notice: 'Food was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = current_user.foods.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def food_params
      params.require(:food).permit(:name, :description)
    end
    
    def measurement_params(params)
        params = ActionController::Parameters.new(params)
        params.permit(:amount, :unit, :calories, :fat, :carbs, :protein)
    end

    def correct_user
		@food = current_user.foods.find_by(id: params[:id])
		redirect_to root_url if @food.nil?
	end
end