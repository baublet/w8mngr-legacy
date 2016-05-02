require 'active_support/concern'

module UserPtMessages
  extend ActiveSupport::Concern

  include do
    store_accessor :preferences
    validates_with UserPreferencesValidator
    after_initialize { setup_preferences }
  end

  def default_preferences
    return {
      "name": "",
      "sex": "na",
      "birthday": "",
      "height": "",
      "height_display": "",
      "timezone": "",
      "units": "i",

      "activity_level": 1,
      "target_calories": 0,

      "pt_messages_food_log": true
    }
  end

  # Sets up the user preferences so that it doesn't blow up if they haven't yet set values
  def setup_preferences
    defaults = default_preferences
    defaults.each do |pref, default|
      if preferences.try(:[], pref).nil?
        preferences[pref.to_s] = default
      end
    end
  end

  # Returns a string representation of their sex
  def sex
    if preferences[:sex] == "m"
      "Male"
    elsif preferences[:sex] == "f"
      "Female"
    else
      "Other / Prefer not to disclose"
    end
  end

  # Returns the default measurement for the user based on their preferences
  def unit measurement = "human-mass"
    case measurement
    when "human-mass"
      return (preferences["unit"] == "m")? "kg" : "lb"
    end
  end

  # Returns the user's age
  def age
    dob = Chronic.parse(preferences["birthday"])
    now = Time.now.utc.to_date
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  # Returns the user's name if it's set, or the email if it isn't
  def name
    preferences[:name].blank? ? email : preferences[:name]
  end

end