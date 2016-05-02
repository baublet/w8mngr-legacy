include ActionView::Helpers::DateHelper

module PersonalTrainer
  module FoodEntries
    # This method takes the date of the last known entry from a user and determines
    # how long it has been since the user's last entry. The second option takes
    # an integer describing the number of hours the user has entered before we
    # start bugging them about entering the next day's calories
    #
    # Params:
    # +last_entry_date+:: an SQL timestamp string of the last entered item
    # +hours_til_bug+:: an integer of hours before we begin bugging the user (default: 24)
    def self.last_entry (last_entry_date, hours_til_bug = 24)
      last_entry_date_s = last_entry_date.to_s
      current_time = DateTime.now
      last_entry_modified = DateTime.parse(last_entry_date_s) + hours_til_bug.hours
      return [] if current_time < last_entry_modified
      # Here, it has been more than hours_til_bug hours since they entered an
      # entry, so let's see how many hours/days it has been and parse that into
      # our message
      type = "food_log_reminder"
      uid = "flr-" + last_entry_date_s
      time_ago = time_ago_in_words(last_entry_date)
      message_text = "You have not entered any foods into your food log in " + time_ago + "."
      # Then return it!
      return [{ text: message_text, type: type, uid: uid}]
    end
  end
end