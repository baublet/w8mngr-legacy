class FoodsController < ApplicationController
  before_action :set_food, only: [:show, :edit, :update, :destroy]

  before_action :logged_in_user, only: [:add, :new, :create, :destroy, :update]
  before_action :correct_user, only: [:update, :destroy]

  include FoodsHelper

  # GET /foods
  def index
    @foods = current_user.foods.all
  end

  # GET /foods/1
  def show
      # Validate the day
      @day = params[:day].blank? ? current_day : validate_day(params[:day])
  end

  def search
      #TODO: save the date they pass in a cookie, if it's passed
      #
  end

  def find
      require 'uri'

      if !params[:q].blank?
          @searchresults = []
          
          # Prepare the pagination with 25 per page
          page = params[:p].blank? || params[:p].to_i < 1 ? 1 : params[:p].to_i
          per_page = 25

          # Search the wider database with a preference for the user's saved and liked foods
          #TODO: Implement a proper Solr search here
          
          # Break the search into its parts and search for each term
          query = params[:q].split
          results = Food.where("name LIKE ?", "%#{query.shift}%")
                        .limit(per_page + 1)
                        .offset((page - 1) * per_page)
          query.each do |term|
              results.where("name LIKE ?", term)
          end
          # We do +1 here because if, at the end, we have 26 entries, we know there's a next page
          @searchresults = results
          
          # We need to ping the USDA for as many entries as we need to get to per_page
          usda_entries = per_page + 1 - results.size
          
          #byebug

          # Then, search the USDA API if we have fewer than per_page + 1 results
          if usda_entries > 0
              @searchresults = @searchresults + search_usda(params[:q], usda_entries, (page - 1) * per_page)
          end

          # Matches? Show the search form
          # Prepare simple pagination
          @prev_page = page > 1 ? (page - 1).to_s : nil
          @next_page = @searchresults.size > per_page ? (page + 1).to_s : nil
          @base_url  = food_find_path + "?q=" + URI.encode(params[:q])
          # Pop the end off the results array so we can stick to per_page items per page
          @searchresults.pop
          render "find"

          #TODO: No matches at all? Tell them and display the new foods form
      else
          render "search"
      end
  end

  # This method downloads the params[:ndbno] from the USDA website if it doesn't already
  # exist and adds it to the database as belonging to our unspecified superuser (id=0).
  # It then redirects the user to the food log page with the entry filled out
  def pull
      ndbno = params[:ndbno]
      @food = Food.find_by(ndbno: ndbno)
      if @food.nil?
          @result = get_usda_entry(ndbno)

          ndbno = @result["ndbno"]
          name = @result["name"]
          @food = Food.new(user_id: 1, name: name, ndbno: ndbno)

          # Loop through the nutrients and build our measurements
          measurements = {}
          @result["nutrients"][0]["measures"].each do |measure|
              measurements[measure["label"]] = {
                  "unit" => measure["label"],
                  "amount" => measure["qty"],
                  "calories" => 0,
                  "fat" => 0,
                  "carbs" => 0,
                  "protein" => 0
              }
          end

          # Calories (always [1])
          @result["nutrients"][1]["measures"].each do |measure|
              measurements[measure["label"]]["calories"] += measure["value"].to_i
          end

          # Fat (always [3])
          @result["nutrients"][3]["measures"].each do |measure|
              measurements[measure["label"]]["fat"] += measure["value"].to_i
          end

          # Carbs (always [4])
          @result["nutrients"][4]["measures"].each do |measure|
              measurements[measure["label"]]["carbs"] += measure["value"].to_i
          end

          # Protein (always [2])
          @result["nutrients"][2]["measures"].each do |measure|
              measurements[measure["label"]]["protein"] += measure["value"].to_i
          end

          measurements.each do |measurement|
              @food.measurements.new(measurement.second)
          end

          if !@food.save
              # TODO: Log this behavior
              flash[:error] = "Unexpected error pulling the food from foreign source. Please contact the administrator."
              redirect_to food_search_path
          end
    end
    # If it saved, or we're already storing this item redirect them to the food entry with this item loaded
    redirect_to @food
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

  # Adds :ndbno from the USDA's database if it isn't already in our database
  def add
    # TODO: Make sure this NDB number isn't already in the database (if it is, just skip the next steps)

    # TODO: Query the NDB api
    # TODO: Build the new food and all of its measurements and save it
    # TODO: If it worked, redirect them to the food log using the cookie they stored, or the current day if it's not there, with the new food's ID
    # TODO: If, for some reason, it failed, we want to notify the admin and throw a pretty fatal error. something went pretty wrong here

    # TODO: If the NDB number is already in the database, just find its id and redirect them as you did above
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
    # TODO: Mark these as "deleted" in the database, because we don't want users to be able to delete
    # foods that are used in other users' recipes...
    @food.destroy
    flash[:success] = 'Food was successfully deleted.'
    redirect_to foods_url
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
