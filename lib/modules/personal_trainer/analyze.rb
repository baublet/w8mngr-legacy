include ActionView::Helpers::DateHelper

module PersonalTrainer
  module Analyze
    def self.user (user)

      messages = []

      # Reminder to enter food entries
      last_entry = user.foodentries.order(day: :desc).limit(1).first
      last_entry_date = last_entry.nil? ? 0 : Date.strptime(last_entry.day.to_s,  "%Y%m%d")
      messages.push(*PersonalTrainer::FoodEntries::last_entry(last_entry_date))

      # Return all of the messages for updating in our DB
      return messages
    end
  end
end