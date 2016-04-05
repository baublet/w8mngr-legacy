class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  before_action :logged_in_user, only: [:add, :new, :create, :destroy, :update]
  before_action :correct_user, only: [:update, :destroy]

  include FoodsHelper

  # GET /foods
  def index
    @foods = current_user.foods.all.where(deleted: false)
  end

  # GET /foods/1
  def show
    # Validate the day
    @day = params[:day].blank? ? current_day : validate_day(params[:day])
  end

  def search
    # If the user is coming from a recipe, make sure the recipe exists and
    # belongs to the user. If it does, save that recipe ID to a cookie so that
    # they can add the food directly to a recipe...
    if !params[:recipe].blank?
      recipe = current_user.recipes.find_by(id: params[:recipe])
      if !recipe.nil?
        cookies[:add_to_recipe] = recipe.id
      end
    end
    # If they're coming from the food log, destroy the add_to_recipe cookie so
    # the user can add entries to their food log
    if !params[:food_log_referrer].blank?
      cookies.delete :add_to_recipe
    end

    if !params[:q].blank?
      @searchresults = []

      # Prepare the pagination with 25 per page
      page = params[:p].blank? || params[:p].to_i < 1 ? 1 : params[:p].to_i
      per_page = 25

      # Search the wider database with a preference for the user's saved and liked foods
      #TODO: Implement a proper Solr search here

      # Break the search into its parts and search for each term
      query = params[:q].squish
      results = Food.search_foods(query)
                    .limit(per_page + 1)
                    .offset((page - 1) * per_page)
      # We do +1 here because if, at the end, we have 26 entries, we know there's a next page
      @searchresults = results

      # We need to ping the USDA for as many entries as we need to get to per_page
      usda_entries = per_page + 1 - results.size

      # Then, search the USDA API if we have fewer than per_page + 1 results
      if usda_entries > 0
        #@searchresults = @searchresults + search_usda(params[:q], usda_entries, (page - 1) * per_page)
        usda = Apis::USDA.new
        @searchresults = @searchresults + usda.search({
          q:      params[:q],
          max:    usda_entries,
          offset: (page - 1) * per_page
          })
      end

      # Matches? Show the search form
      # Prepare simple pagination
      @prev_page = page > 1 ? (page - 1).to_s : nil
      @next_page = @searchresults.size > per_page ? (page + 1).to_s : nil
      @base_url  = food_search_path + "?q=" + URI.encode(params[:q])
      # Pop the end off the results array so we can stick to per_page items per page
      @searchresults.pop
      render "find"

      #TODO: No matches at all? Tell them and display the new foods form
    else
      render "search"
    end
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
        flash.now[:success] = "Your food was successfully created!"
        @newmeasurement = Measurement.new
        render :edit
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
    # Use callbacks to share common setup or constraints between actions.
    def set_food
      @food = Food.find(params[:id])
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
