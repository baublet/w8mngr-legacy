class FoodsController < ApplicationController
  before_action :logged_in_user, only: [:add, :new, :create, :destroy, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  include FoodsHelper

  def index
    per_page = 10
    @page = (params.try(:[], :p) || 1).to_i
    @prev_page = @page == 1 ? nil : @page - 1
    @foods = current_user.foods.includes(:measurements).where(deleted: false).offset(per_page * (@page - 1)).limit(per_page + 1)
    @foods = @foods.to_a
    # If there are 11 foods, there's a next page, otherwise make the next_page nil
    @next_page = @foods.count > 10 ? @page + 1 : nil
    @paginator_url = foods_path
    @foods.pop if @foods.count > 10
  end

  def show
    @food = Food.includes(:measurements).find(params[:id])
    # Validate the day
    @day = params[:day].blank? ? current_day : validate_day(params[:day])
    respond_to do |format|
      format.html { render "show" }
      format.json {
        render json:
          {
            food:        @food.name,
            id:          @food.id,
            description: @food.description,
            measurements:@food.measurements
          }
      }
    end
  end

  def new
    @food = current_user.foods.new
    @newmeasurement = Measurement.new
  end

  def edit
    @newmeasurement = Measurement.new
  end

  def create
    @food = current_user.foods.new food_params
    @measurement = @food.measurements.new measurement_params

    if @food.save
        flash.now[:success] = "Your food was successfully created!"
        redirect_to edit_food_path(@food)
    else
        @food.measurements.clear
        @newmeasurement = @measurement
        render :new
    end
  end

  def update

    @newmeasurement = Measurement.new
    food_updated = true

    if new_measurement_data_passed? && food_updated == true
      @newmeasurement = @food.measurements.new(measurement_params)
      food_updated = "Could not create new measurement." if !@newmeasurement.save
      # Reload this if we updated the food so we can delete all of our current
      # measurements while adding a new one
      @food.reload if food_updated == true
    end

    # We update the food itself second so our validation occurs (which extends to
    # measurement models) after the user modifies the measurements
    food_updated = "Food failed to update." unless @food.update(food_params)
    food_updated = @food.update_measurements(params.try(:[], :measurement)) if food_updated == true

    # If everything checks out, reset the new measurement
    # Reload the food to refresh our measurements
    @food.reload
    if food_updated == true
      @newmeasurement = Measurement.new
      flash.now[:success] = "Food successfully saved."
    else
      flash.now[:error] = food_updated
    end

    render :edit
  end

  # DELETE /foods/1
  def destroy
    # Mark these as "deleted" in the database, because we don't want users to be able to delete
    # foods that are used in other users' recipes...
    @food.update(deleted: 1)
    flash[:success] = 'Food was successfully deleted.'
    redirect_to foods_url
  end

  private

  # Only allow a trusted parameter "white list" through.
  def food_params
    params.require(:food).permit(:name, :description)
  end

  def correct_user
    @food = current_user.foods.find_by(id: params[:id])
    redirect_to root_url if @food.nil?
  end

  def new_measurement_data_passed?
    new_measurement_params = params.try(:[], :measurement).try(:[], '0')
    return false if new_measurement_params.nil?
    return true if  !new_measurement_params[:amount].blank? ||
                    !new_measurement_params[:unit].blank? ||
                    !new_measurement_params[:calories].blank? ||
                    !new_measurement_params[:fat].blank? ||
                    !new_measurement_params[:carbs].blank? ||
                    !new_measurement_params[:protein].blank?
    return false
  end

  def measurement_params
    params.require(:measurement).require('0').permit(:amount, :unit, :calories, :fat, :carbs, :protein)
  end

end
