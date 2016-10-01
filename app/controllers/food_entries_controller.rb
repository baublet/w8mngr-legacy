class FoodEntriesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:update, :destroy]
  before_action :find_entry, only: [:update, :destroy]

  include FoodsHelper

  def index
    respond_to do |format|
      format.html { show_list }
      format.json { show_list :json }
    end
  end

  def create
    @newfoodentry = current_user.foodentries.build(food_entry_params)
    if @newfoodentry.save
      flash.now[:success] = "Entry added."
      @newfoodentry = current_user.foodentries.build(day: current_day, calories: nil)
    else
      flash.now[:error] = "Unable to save entry."
    end
    respond_to do |format|
      format.html {
        show_list
      }
      format.json { render json: {success: true, id: @newfoodentry.try(:id)} }
    end
  end

  def update
    if @foodentry.update(food_entry_params)
      flash.now[:success] = "Entry updated."
    else
      flash.now[:error] = "Unable to update entry."
    end
    respond_to do |format|
      format.html { show_list }
      format.json { render json: {success: true} }
    end
  end

  def destroy
    flash.now[:success] = "Entry deleted." if @foodentry.destroy
    respond_to do |format|
      format.html { show_list }
      format.json { render json: {success: true} }
    end
  end

  # Adds a food to the user's last-viewed day (or the current day) based on measurement (its id) and the amount as a multiplier to the measurement
  def add_food
    # Validate the day
    @day = !cookies[:last_day].present? ? current_day : validate_day(cookies[:last_day])
    # Load up the food in this entry
    @food_entry = current_user.foodentries.build(day: @day)
    @food_entry.populate_with_food(params[:measurement_id], params[:amount])
    if @food_entry.save
      # Redirect them back to that day
      flash[:success] = "Food added to your log."
      increment_popularity @food_entry.id, params[:measurement_id]
    else
      # TODO: Log this behavior
      flash[:error] = "Error adding the food to your log..."
    end
    redirect_to food_log_day_path(@day)
  end

  private

  def find_entry
    @foodentry = current_user.foodentries.find(params[:id])
    show_404("Invalid food entry...") and return false if @foodentry.nil?
  end

  def food_entry_params
    params.require(:food_entry)
        .permit(:description, :calories, :fat, :carbs, :protein, :day)
  end

  def correct_user
    @foodentry = current_user.foodentries.find_by(id: params[:id])
    redirect_to root_url if @foodentry.nil?
  end

  def show_list format = :html
    # Saves the last viewed day in a cookie
    cookies[:last_day] = current_day
    @foodentries = current_user.foodentries_from(current_day)
    if format == :html
      @totals = current_user.food_totals(current_day)
      @newfoodentry ||= current_user.foodentries.build(day: current_day, calories: nil)
      render "index"
    else
      render json: {current_day: current_day, entries: @foodentries}
    end
  end
end
