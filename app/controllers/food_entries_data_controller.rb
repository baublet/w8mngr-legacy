class FoodEntriesDataController < ApplicationController
  before_action :logged_in_user

  def index
    data = process_data params[:column]
    respond_to do |format|
      format.json { render json: data }
    end
  end

  private

  def process_data column
    id = current_user.id
    data = FoodEntryData.new(food_entry_data_params)
    data.id = id
    return data.time_data column
  end

  def food_entry_data_params
    params.permit(:length, :length_scope)
  end

end