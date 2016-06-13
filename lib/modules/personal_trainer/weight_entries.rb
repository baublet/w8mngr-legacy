include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

module PersonalTrainer
  module WeightEntries
    # This method takes the date of the last known entry from a user and determines
    # how long it has been since the user's last entry. The second option takes
    # an integer describing the number of hours the user has entered before we
    # start bugging them about entering the next day's weight
    #
    # Params:
    # +last_entry_date+:: an SQL timestamp string of the last entered item
    # +hours_til_bug+:: an integer of hours before we begin bugging the user (default: 24)
    def self.last_entry (last_entry_date, hours_til_bug = 24)
      # We can never bug people before 12 hours have passed
      return [] unless hours_til_bug >= 12

      # Don't  bug people if they don't have any entries
      return [] if last_entry_date == 0

      last_entry_date_s = last_entry_date.to_s
      current_time = DateTime.now
      last_entry_modified = DateTime.parse(last_entry_date_s) + hours_til_bug.hours
      return [] if current_time < last_entry_modified

      # Build the message!
      type = "weight_log_reminder"
      uid = "wlr-" + last_entry_date_s
      time_ago = time_ago_in_words(last_entry_date)
      message_text = "You have not logged your weight in " + time_ago + ". With more entries, we can better track your progress, and you can get a more firm sense of your weight fluctuations!"
      message_html = "<p>" + message_text + "</p>"
      message_text = message_text + "\n\n" + "Get back at it: " + Rails.application.routes.url_helpers.weightlog_url(host: Rails.configuration.x.host)
      message_html = "<p>Get back at it and <a href=\"" + Rails.application.routes.url_helpers.weightlog_url(host: Rails.configuration.x.host) + "\">log today's weight</a>!</p>"
      subject = "Reminder: " + time_ago  + " since your last weigh-in"

      # Then return it!
      return [{
                subject: subject,
                message: message_text,
                message_html: message_html,
                type: type,
                uid: uid,
                mood: 0
      }]
    end
  end
end