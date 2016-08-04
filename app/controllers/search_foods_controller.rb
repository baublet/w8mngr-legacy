class SearchFoodsController < ApplicationController

  def index

    # If the user is coming from a recipe, make sure the recipe exists and
    # belongs to the user. If it does, save that recipe ID to a cookie so that
    # they can add the food directly to a recipe... If they aren't coming from
    # from a recipe, delete the add_to_recipe cookie.
    if params[:recipe].blank? && params[:q].blank?
      cookies.delete :add_to_recipe
    else
      @recipe = current_user.recipes.find_by(id: params[:recipe])
      unless @recipe.nil?
        cookies[:add_to_recipe] = @recipe.id
      end
    end

    # Load our recipe if we're looking to add ingredients to one
    @recipe = current_user.recipes.find_by(id: cookies[:add_to_recipe]) unless cookies[:add_to_recipe].nil? || !@recipe.nil?

    # Set our templates' default variables
    @searchresults = []
    @prev_page = nil
    @next_page = nil
    @base_url  = food_search_path
    @search_type = "Foods"

    if !params[:q].blank?
      search_foods  (params[:format] == "json")
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

  def recipes
    # Set our templates' default variables
    @searchresults = []
    @prev_page = nil
    @next_page = nil
    @base_url  = recipe_search_path
    @search_type = "Recipes"

    if !params[:q].blank?
      search_recipes
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

  # Abstracting this out to send back autocomplete results to the Javascript API
  # on all autocomplete results
  def search_recipes
    # Prepare the pagination with 30 per page
    page = params[:p].blank? || params[:p].to_i < 1 ? 1 : params[:p].to_i
    per_page = 30

    # Break the search into its parts and search for each term
    query = params[:q].squish
    results = Recipe.search_recipes(query)
                    .limit(per_page + 1)
                    .offset((page - 1) * per_page)
    # We do +1 here because if, at the end, we have per_page + 1 entries, we know there's a next page
    @searchresults = results

    # Matches? Show the search form
    # Prepare simple pagination
    @prev_page = page > 1 ? (page - 1).to_s : nil
    @next_page = @searchresults.size > per_page ? (page + 1).to_s : nil
    @base_url  = recipe_search_path + "?q=" + URI.encode(params[:q])
    # Pop the end off the results array so we can stick to per_page items per page
    @searchresults.try(:pop)
  end

  # I'm abstracting this out because in a JSON end point, we're going to want
  # to return search results for both recipes and foods
  def search_foods json = false
    # Prepare the pagination with 10 per page
    page = params[:p].blank? || params[:p].to_i < 1 ? 1 : params[:p].to_i
    per_page = params[:per_page] || 10
    per_page = per_page.to_i

    # Search the wider database with a preference for the user's saved and liked foods

    # Break the search into its parts and search for each term
    if json
      # Our JSON query searches for LIKE instead
      query = params[:q].squish.gsub(" ", "%")
      query = "%#{query}%"
      # Cache this request
      results = Rails.cache.fetch("json-food-search-" + query + "-p-" + page, :expires_in => 12.hours) do
        Food.where("name LIKE :q OR description LIKE :q", {q: query})
            .order("popularity ASC")
            .limit(per_page + 1)
            .offset((page - 1) * per_page)
            .includes(:measurements)
      end
    else
      query = params[:q].squish
      results = Food.search_foods(query)
                    .limit(per_page + 1)                          # We do +1 here because if, at the end, we have per_page + 1 entries, we know there's a next page
                    .offset((page - 1) * per_page)
                    .includes(:measurements)
    end

    @searchresults = results.each { |x| x.data_source = "local" }

    # Matches? Show the search form
    # Prepare simple pagination
    @prev_page = page > 1 ? (page - 1).to_s : nil
    @next_page = @searchresults.size > per_page ? (page + 1).to_s : nil
    @base_url  = food_search_path + "?q=" + URI.encode(params[:q])
    # Pop the end off the results array so we can stick to per_page items per page
    @searchresults.try(:pop)
  end

end
