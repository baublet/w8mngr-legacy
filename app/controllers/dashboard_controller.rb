class DashboardController < ApplicationController
  before_action :logged_in_user

  def index
    respond_to do |format|
      format.json { render json: week_in_review }
      format.html { render "index" }
    end
  end

  def week_in_review
    week_averages = current_user.week_average

    data = FoodEntryData.new(user_id: current_user.id, num: 8, length_scope: "day")
    week_calories = data.time_data("calories").to_a
    week_fat = data.time_data("fat").to_a
    week_carbs = data.time_data("carbs").to_a
    week_protein = data.time_data("protein").to_a

    week_weights = WeightEntry.where(user_id: current_user.id)
                                .group_by_day(:day_ts, default_value: 0, last: 8)
                                .average(:value)
                                .to_a
    return {
      week_averages: week_averages,
      week_calories: week_calories,
      week_fat: week_fat,
      week_carbs: week_carbs,
      week_protein: week_protein,
      week_weights: week_weights
    }
  end
end