class FoodEntriesDataController < ApplicationController
  before_action :logged_in_user

  def index
    key = "food-entries-data-" + current_user.id.to_s + "-" + params[:num] + "-" + params[:length_scope]
    data = Rails.cache.fetch(key, :expires_in => 24.hours) do
      process_data
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

  private

  def process_data
    id = current_user.id
    length = params[:num].to_i
    length_scope = params[:length_scope]
    data = FoodEntryData.new(user_id: id, num: length, length_scope: length_scope)
    return data.time_data params[:column]
  end

end