class FoodEntriesDataController < ApplicationController
  before_action :logged_in_user

  def calories
    data = process_data :calories
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def fat
    data = process_data :fat
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def carbs
    data = process_data :carbs
    respond_to do |format|
      format.json { render json: data }
    end
  end

  def protein
    data = process_data :protein
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
    params.permit(:column, :length, :scope)
  end

end