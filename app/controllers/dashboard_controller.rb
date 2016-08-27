class DashboardController < ApplicationController
  before_action :logged_in_user
  include ActionView::Helpers::DateHelper

  def index
    @dashboard_data = Rails.cache.fetch("user-dashboard-" + current_user.id.to_s, :expires_in => 1.second) do
      @dashboard_data = week_in_review
      @dashboard_data = week_macros(@dashboard_data).merge(@dashboard_data)
      @dashboard_data = user_stats.merge(@dashboard_data)
    end
    respond_to do |format|
      format.json { render json: @dashboard_data }
      format.html {
        @week_averages = @dashboard_data[:week_averages]
        @week_weights = @dashboard_data[:week_weights]
        @week_calories = @dashboard_data[:week_calories]
        @week_fat = @dashboard_data[:week_fat]
        @week_carbs = @dashboard_data[:week_carbs]
        @week_protein = @dashboard_data[:week_protein]
        @week_differential = @dashboard_data[:week_differential]
        render "index"
      }
    end
  end

  private

  def user_stats
    # Get their TDEE and Adaptive TDEE
    # We're wrapping this in a stats routine because in the future, I'll probably
    # expand this functionality
    return {
      tdee: current_user.bmr,
      atdee: current_user.adaptive_tdee
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

    # Now we want to calculate the calories burned/gained, including activities
    tdee = current_user.differential_metric
    days_needed = week_calories.collect { |e| date_to_day e[0] }      # Collect all the days we need to iterate through
    activities = ActivityEntry.where(user_id: current_user.id, day: days_needed).to_a

    # Clone our calories array (if we don't do this, ruby uses pointers for everything)
    week_differential = week_calories.map { |a| a.dup }
    week_differential.each do |day|
      next if day[1] == 0
      today = date_to_day(day[0]).to_i
      # Subtract this day's calories from the TDEE
      day[1] = day[1] - tdee unless day[1] == 0
      # And subtract all the activity calories from the day's calories
      activities.each do |activity|
        day[1] = day[1] - activity.calories if activity.day == today
      end
    end

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
      week_weights: week_weights,
      week_differential: week_differential
    }
  end
end