class UsdaController < ApplicationController

  include FoodsHelper

  # This method downloads the params[:ndbno] from the USDA website if it doesn't already
  # exist and adds it to the database as belonging to our superuser (id=1).
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

end
