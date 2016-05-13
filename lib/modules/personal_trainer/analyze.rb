include ActionView::Helpers::DateHelper
require 'date'
include ApplicationHelper

module PersonalTrainer
  module Analyze
    def self.user (user)

      messages = []

      # Reminder to enter food entries
      last_entry = user.foodentries.order(day: :desc).limit(1).first
      last_entry_date = last_entry.nil? ? 0 : Date.strptime(last_entry.day.to_s,  "%Y%m%d")
      messages.push(*PersonalTrainer::FoodEntries::last_entry(last_entry_date, 24, user.preferences["faturday_enabled"]))

      # Only do this message on Wednesday and Saturday
      today = Date.today
      target = user.preferences["target_calories"].to_i
      if target > 0 && (today.saturday? || today.wednesday?)
        # Calories for the last 5 days, beginning on the day before
        # 1. Get the days we want to queue
        today = today.strftime('%Y%m%d')
        last_day = today
        days = []
        5.times do
          last_day = ApplicationHelper::day_before(last_day)
          days << last_day
        end
        # 2. Get the calories from each of those days
        data_to_pass = []
        days.each do |day|
          day_totals = user.food_totals(day)
          day_totals[:day] = day
          data_to_pass << day_totals
        end
        # 3. Pass the data to our personal trainer
        messages.push(*PersonalTrainer::FoodEntries::calorie_targets(data_to_pass, target))
      end


      # Return all of the messages for updating in our DB
      return messages
    end
  end
end