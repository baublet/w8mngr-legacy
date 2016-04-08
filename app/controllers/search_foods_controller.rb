class SearchFoodsController < ApplicationController

  def index
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

    # Set our templates' default variables
    @searchresults = []
    @prev_page = nil
    @next_page = nil
    @base_url  = food_search_path

    if !params[:q].blank?
      search_foods
    end
    respond_to do |format|
      format.html { render "search" }
      format.json {
        render json:
          {
            prev_page: @prev_page,
            next_page: @next_page,
            results: @searchresults
          }
      }
    end
  end

  protected

  # I'm abstracting this out because in a JSON end point, we're going to want
  # to return search results for both recipes and foods
  def search_foods
    # Prepare the pagination with 25 per page
    page = params[:p].blank? || params[:p].to_i < 1 ? 1 : params[:p].to_i
    per_page = 25

    # Search the wider database with a preference for the user's saved and liked foods

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
  end

end
