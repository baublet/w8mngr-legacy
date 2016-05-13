include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

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
    # +faturday_enabled+:: a boolean indicating whether the user has faturdays enabled or not (default: false)
    def self.last_entry (last_entry_date, hours_til_bug = 24, faturday_enabled = false)
      faturday_enabled = YAML.load faturday_enabled rescue false
      # We can never bug people before 12 hours have passed
      return [] unless hours_til_bug >= 12

      # Don't  bug people if they don't have any entries
      return [] if last_entry_date == 0

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
      faturday_url = Rails.application.routes.url_helpers.faturday_url(host: Rails.configuration.x.host)
      message_text = "You have not entered any foods into your food log in " + time_ago + ". Remember, consistency and discipline are the keys to success!"
      message_html = "<p>" + message_text + "</p>"
      message_text += "\n\nGet back on the wagon: " + Rails.application.routes.url_helpers.foodlog_url(host: Rails.configuration.x.host)
      message_html += "<p>Get back on the wagon: <a href=\"" + Rails.application.routes.url_helpers.foodlog_url(host: Rails.configuration.x.host) + "\">Go to My Food Log</a></p>"
      if faturday_enabled
        message_text += "\n\nMake today Faturday? " + faturday_url
        message_html += "<p>Make today <a href=\"" + faturday_url + "\">Faturday</a>?</p>"
      end
      subject = "Don't forget to update your foodlog!"

      # Then return it!
      return [{ message: message_text, message_html: message_html, subject: subject, type: type, uid: uid, mood: 0}]
    end

    # This method takes an array of the past x number of days' calories with the
    # user's target calories. It returns an array of messages (only ever just one)
    # telling the user of how many calories they have gained or lost over the past
    # number of days.
    #
    # Note: this function should only be called once every week, or once every
    # few days, max. We don't want our users getting bombarded with these messages.
    #
    # Params:
    # +calories+:: An array of calories corresponding to the last x number of days,
    # in the format [{day: YYYYMMDD, calories: int}, ...]
    # +target+:: An int of the user's target calories
    def self.calorie_targets (last_entries, target)

      return [] unless last_entries.kind_of?(Array) && target.kind_of?(Integer)

      over_under = 0
      valid_days = 0
      last_entries.each do |day|
        # Calories have to be over 0 for us to count them
        next if day[:calories] == 0 || day[:calories].nil?
        valid_days += 1
        over_under += day[:calories] - target
      end

      # Only do any sort of message if the number is +/- 10% of the target and
      # the number of valid, tracked days was more than 3
      padding = target * 0.1
      return [] unless over_under.abs >= padding && valid_days > 2

      pretty = number_with_delimiter(over_under.abs)
      message = ""

      if over_under > 0
        mood = 2
        message = "Uh oh! You have been over your target calories by "
        message += pretty + " calories"
        message += " over the last few days. Don't sweat it! Tomorrow is a new day."
        subject = "Don't sweat it. Tomorrow's a new day!"
      else
        mood = 1
        message = "You're doing great! You have stayed under your target calories by "
        message += pretty + " calories"
        message += " over the last few. Keep up the good work!"
        subject = "Fantastic work lately!"
      end

      type = "target_calories_reminder"
      uid = "tcr-" + pretty

      # Return our message string!
      return [{ message: message, message_html: message, subject: subject, type: type, uid: uid, mood: mood}]

    end
  end
end