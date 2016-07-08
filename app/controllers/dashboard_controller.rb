class DashboardController < ApplicationController
  before_action :logged_in_user
  include ActionView::Helpers::DateHelper

  def index
    respond_to do |format|
      format.json {
        data = Rails.cache.fetch("user-dashboard-" + current_user.id.to_s, :expires_in => 24.hours) do
          data = week_in_review
          data = week_macros(data).merge(data)
          data = user_stats.merge(data)
        end
        render json: data
      }
      format.html { render "index" }
    end
  end

  private

  def user_stats
    # Get their TDEE and Adaptive TDEE
    tdee = current_user.bmr
    atdee = current_user.adaptive_tdee

    # Get their first weight-in and most recent
    first_weight = current_user.weightentries.first
    last_weight = current_user.weightentries.last
    weight_difference = first_weight.value - last_weight.value
    max_weight =  current_user.weightentries.maximum(:value)
    min_weight = current_user.weightentries.minimum(:value)

    return {
      tdee: tdee,
      atdee: atdee,
      first_weight: first_weight.display_value,
      last_weight: last_weight.display_value,
      weight_difference: WeightEntry.get_display_value(weight_difference, current_user.unit),
      first_weight_date: first_weight.day_ts,
      last_weight_date: last_weight.day_ts,
      first_last_difference: distance_of_time_in_words(first_weight.day_ts, last_weight.day_ts),
      max_weight: WeightEntry.get_display_value(max_weight, current_user.unit),
      min_weight: WeightEntry.get_display_value(min_weight, current_user.unit)
    }

  end

  def week_macros data
    return {
      fat: data[:week_fat].map{ |a| a[1] }.inject(:+),
      carbs: data[:week_carbs].map{ |a| a[1] }.inject(:+),
      protein: data[:week_protein].map{ |a| a[1] }.inject(:+),
    }
  end

  def week_in_review
    week_averages = current_user.week_average

    # For FoodEntries and Weight, we grab the last 8 so we can exclude the
    # current day, which might not be filled out

    data = FoodEntryData.new(user_id: current_user.id, num: 8, length_scope: "day")
    week_calories = data.time_data("calories").to_a
    week_fat = data.time_data("fat").to_a
    week_carbs = data.time_data("carbs").to_a
    week_protein = data.time_data("protein").to_a

    week_weights = WeightEntry.where(user_id: current_user.id)
                                .group_by_day(:day_ts, default_value: 0, last: 8)
                                .average(:value)
                                .to_a

    # Turn them to the proper unit
    week_weights = week_weights.map { |w| [w[0], WeightEntry.get_display_value(w[1], current_user.unit)] }

    # Pop the last item from each
    week_calories.pop
    week_fat.pop
    week_carbs.pop
    week_protein.pop
    week_weights.pop

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