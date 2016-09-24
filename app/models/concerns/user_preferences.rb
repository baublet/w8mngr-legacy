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
      "differential_metric": 1,

      "faturday_enabled": false,
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

      "alerts": {
        "food_log_reminder": true,
        "food_log_reminder_hours": 36,
        "target_calories_reminder": true
      }
    }
  end

  # Sets the preferences to the user that you pass in
  def set_preferences preferences

    set_height preferences["height_display"] if preferences.try(:[], "height_display")
    set_birthday preferences["birthday"] if preferences.try(:[], "birthday")
    self.preferences["sex"] = preferences["sex"] if preferences.try(:[], "sex")
    self.preferences["timezone"] = preferences["timezone"] if preferences.try(:[], "timezone")
    self.preferences["units"] = preferences["units"] if preferences.try(:[], "units")
    self.preferences["name"] = preferences["name"] if preferences.try(:[], "name")

    set_target_calories preferences["target_calories"] if preferences.try(:[], "target_calories")
    set_activity_level preferences["activity_level"] if preferences.try(:[], "activity_level")

    self.preferences["faturday_enabled"] = (preferences["faturday_enabled"] ? true : false) if preferences.try(:[], "faturday_enabled")
    set_auto_faturdays preferences["auto_faturdays"] if preferences.try(:[], "auto_faturdays")

    self.preferences["faturday_calories"] = preferences["faturday_calories"].to_i if preferences.try(:[], "faturday_calories")
    self.preferences["faturday_fat"] = preferences["faturday_fat"].to_i if preferences.try(:[], "faturday_fat")
    self.preferences["faturday_carbs"] = preferences["faturday_carbs"].to_i if preferences.try(:[], "faturday_carbs")
    self.preferences["faturday_protein"] = preferences["faturday_protein"].to_i if preferences.try(:[], "faturday_protein")

    set_differential_metric preferences["differential_metric"] if preferences.try(:[], "differential_metric")

  end

  def set_height height_display
    height_display = height_display.gsub("''", "\"")  # Some folks use double-single quotes ('') rather than " to denote inches
    begin
      height_cm = height_display.to_unit.convert_to("cm").scalar.to_i
    rescue
      height_cm = nil
    end
    self.preferences["height_cm"] = height_cm
    self.preferences["height_display"] = height_display
  end

  def set_birthday birthday
    date_time = Chronic.parse(birthday)
    self.preferences["birthday"] = date_time.nil? ? "" : date_time.strftime("%B %-d, %Y")
  end

  def set_target_calories calories
    target_calories = calories.to_i
    self.preferences["target_calories"] = target_calories > 300 ? target_calories : ""
  end

  def set_activity_level level
    activity_level = level.to_i
    self.preferences["activity_level"] = activity_level.between?(1,5) ? activity_level : 2
  end

  def set_auto_faturdays faturdays
    self.preferences["auto_faturdays"] = {}
    if faturdays.try(:[], "faturday")
      faturdays["faturday"].each do |day|
        self.preferences["auto_faturdays"][day] = true
      end
    end
  end

  def set_differential_metric metric
    diff_metric = metric.to_i
    self.preferences["differential_metric"] = diff_metric.between?(1, 4) ? diff_metric : 1
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

  def differential_metric
    case self.preferences["differential_metric"]
      when "1"
        expended_values = []
        expended_values << self.bmr.to_i
        expended_values << self.adaptive_tdee.to_i
        expended_values << self.preferences["target_calories"].to_i
        return expended_values.max unless expended_values.max < 100
      when "2"
        return self.preferences["target_calories"].to_i unless self.preferences["target_calories"].to_i < 100
      when "3"
        return self.bmr.to_i unless self.bmr.nil?
      when "4"
        return self.adaptive_tdee.to_i unless self.adaptive_tdee.nil?
    end

    # Our default differential metric
    return 2200
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
  def unit measurement = :mass
    case measurement
    when :mass
      return (self.preferences["unit"] == "m") ? "kg" : "lb"
    when :distance
      return (self.preferences["unit"] == "m") ? "km" : "miles"
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