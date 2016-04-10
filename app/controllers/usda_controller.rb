class UsdaController < ApplicationController

  include FoodsHelper

  # This method downloads the params[:ndbno] from the USDA website if it doesn't already
  # exist and adds it to the database as belonging to our superuser (id=1).
  # It then redirects the user to the food log page with the entry filled out
  def pull
    ndbno = params[:ndbno]
    @food = Food.find_by(ndbno: ndbno)

    if @food.nil?

      usda = Apis::USDA.new
      result = usda.get_food(ndbno)

      ndbno = result["ndbno"]
      name = result["name"]

      @food = Food.new(user_id: 1, name: name, ndbno: ndbno)
      @food.populate_from_usda result
      @food.save

    end

    respond_to do |format|
      format.html {
        # If it saved, or we're already storing this item redirect them to the food entry with this item loaded
        redirect_to @food
      }
      format.json {
        render json:
          {
            food:         @food.name,
            id:           @food.id,
            ndbno:        @food.ndbno,
            description:  @food.description,
            measurements: @food.measurements
          }
      }
    end
  end

end
