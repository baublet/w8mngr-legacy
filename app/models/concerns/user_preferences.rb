require 'active_support/concern'

module UserPreferences
  extend ActiveSupport::Concern

  included do
    store_accessor :preferences
    validates_with UserPreferencesValidator
    after_initialize { setup_preferences }
  end

  def default_preferences
    {
      "name": "",
      "sex": "na",
      "birthday": "",
      "height": "",
      "height_display": "",
      "timezone": "",
      "units": "i",

      "activity_level": 2,
      "target_calories": "",

      "faturdays": false,
      "auto_faturdays": {
        "mo": false,
        "tu": false,
        "we": false,
        "th": false,
        "fr": false,
        "sa": false,
        "su": false
      },
      "faturday_calories": "",
      "faturday_fat": "",
      "faturday_carbs": "",
      "faturday_protein": "",

      "pt_messages_food_log": true
    }
  end

  # Sets up the user preferences so various functions don't blow up if they haven't yet set values
  def setup_preferences
    defaults = default_preferences
    defaults.each do |pref, default|
      if self.preferences.try(:[], pref.to_s).nil?
        self.preferences[pref.to_s] = default
      end
    end
  end

  # Returns a string representation of their sex
  def sex
    if self.preferences["sex"] == "m"
      "Male"
    elsif self.preferences["sex"] == "f"
      "Female"
    else
      "Other / Prefer not to disclose"
    end
  end

  # Returns the default measurement for the user based on their preferences
  def unit measurement = "human-mass"
    case measurement
    when "human-mass"
      return (self.preferences["unit"] == "m")? "kg" : "lb"
    end
  end

  # Returns the user's age
  def age
    begin
      dob = Chronic.parse(self.preferences["birthday"])
      now = Time.now.utc.to_date
      return now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    rescue
      return nil
    end
  end

  # Returns the user's name if it's set, or the email if it isn't
  def name
    self.preferences["name"].blank? ? self.email : self.preferences["name"]
  end

end