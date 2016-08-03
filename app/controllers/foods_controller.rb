class FoodsController < ApplicationController
  before_action :logged_in_user, only: [:add, :new, :create, :destroy, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  include FoodsHelper

  # GET /foods
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

  # GET /foods/1
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

  # GET /foods/new
  def new
    @food = current_user.foods.new
    @newmeasurement = Measurement.new
  end

  # GET /foods/1/edit
  def edit
    @newmeasurement = Measurement.new
  end

  # POST /foods
  def create
    @food = current_user.foods.new(food_params)
    @measurement = @food.measurements.new(measurement_params(params[:measurement]['0']))

    if @food.save
        flash.now[:success] = "Your food was successfully created!"
        redirect_to edit_food_path(@food)
    else
        @food.measurements.clear
        @newmeasurement = @measurement
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
                  if params[:measurement][measurement.id.to_s][:delete] == 'yes'
                      # We don't want to delete the last measurement on a food item
                      if @food.measurements.size > 1
                          measurement.destroy
                          # We have to reload here so the food associations are updated
                          @food.reload
                      else
                          food_update_error = "Can't delete the selected measurement(s). You need at least one measurement on a food entry."
                      end
                  else
                      if !measurement.update( measurement_params(params[:measurement][measurement.id.to_s]) )
                          food_update_error = "One or more of your measurements failed to save."
                      end
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
                  @food.reload
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

  def measurement_params(params)
      params = ActionController::Parameters.new(params)
      params.permit(:amount, :unit, :calories, :fat, :carbs, :protein)
  end

  def correct_user
    @food = current_user.foods.find_by(id: params[:id])
    redirect_to root_url if @food.nil?
  end
end
