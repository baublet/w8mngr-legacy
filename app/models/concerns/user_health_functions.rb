require 'active_support/concern'

module UserHealthFunctions
  extend ActiveSupport::Concern

  def recent_most_weight
    weightentries.last
  end

  # Returns nil if there isn't enough information about the user to make a calculation
  def bmr

    # Convert the recent rate from G to LBs
    recent_weight = self.recent_most_weight
    recent_weight = recent_weight.nil? ? nil : self.recent_most_weight.value.to_s + "g"
    recent_weight = recent_weight.nil? ? nil : recent_weight.to_unit.convert_to("lbs").scalar.to_i

    user_age = self.age

    # Require at least these parameters before being able to calculate BMR
    return nil if preferences["height"].blank? || user_age.nil? || recent_weight.nil?

    # If there's no sex stated, assume the person is female (because it estimates lower)
    sex = preferences["sex"] == "m" ? "m" : "f"

    # Our activity levels correspond to a percentage above
    activity = preferences["activity_level"].blank? ? 2 : preferences["activity_level"].to_i
    activity_multiplier = 1 + (activity / 10)

    # Calculate our height from CM to IN
    height = preferences["height"] + "cm"
    height = height.to_unit.convert_to("in").scalar.to_i

    bmr = 0
    if sex == "m"
      bmr = 66 + (6.3 * recent_weight) + (12.9 * height) - (6.8 * user_age)
    else
      bmr = 655 + (4.3 * recent_weight) + (4.7 * height) - (4.7 * user_age)
    end
    return (bmr * activity_multiplier).ceil
  end

  # Returns a hash of the averages of weights, calories, fats, carbs, and proteins
  # of the week
  #
  # Because groupdate starts weeks on arbitrary days, rather than working with the last
  # 7 days, we have to just get the last 7 days and average them manually
  def week_average
    averages = {}
    data_obj = FoodEntryData.new(user_id: id, num: 7, length_scope: "day")
    averages["calories"] = average_of data_obj.time_data("calories")
    averages["fat"] = average_of data_obj.time_data("fat")
    averages["carbs"] = average_of data_obj.time_data("carbs")
    averages["protein"] = average_of data_obj.time_data("protein")
    averages["weights"] = average_of WeightEntryData.new(user_id: id, num: 7, length_scope:"day")
                                         .time_data()
    return averages
  end

  def average_of data
    values = data.map { |v| v[1] }
    values = values.select { |v| true if v > 0 }
    return nil if values.size < 1
    return (values.inject(:+) / values.size).ceil
  end

  def at_least_one number
    number = number.to_i
    return 1 if number == 0
    return number
  end

  # Returns a calculated adaptive BMR based on weight entries and calories.
  # Returns nil if there aren't enough data points.
  def adaptive_tdee (uid = nil, max_weeks = 12, min_weeks = 2)

    uid = id if uid.nil?

    # Now, calculate their TDEE using the first week as our baseline
    calories = FoodEntryData.new(user_id: uid, num: 12, length_scope: "week")
                            .time_data("calories")
    weights =  WeightEntryData.new(user_id: uid, num: 12, length_scope: "week")
                              .time_data()

    tdee = 0
    last_calories = 0
    last_weight = 0
    calories.each_with_index do |week, key|
      # byebug
      # Do nothing if there's no weight or calorie average
      next if !week[1].present? || week[1].to_i == 0
      next if !weights[key].present?
      next if !weights[key][1].present? || weights[key][1].to_i == 0
      if tdee == 0
        tdee = week[1]
        last_weight = weights[key][1]
        last_calories = week[1]
        next
      end
      weight_difference = weights[key][1] / last_weight
      calorie_difference = week[1] / last_calories
      if weight_difference == 1
        # If there's no weight difference, average the calories for the two weeks
        # and set that as their TDEE
        tdee = (tdee + week[1]) / 2
      else
        # Otherwise, average the differences
        adjustment = (weight_difference + calorie_difference) / 2
        tdee = tdee * adjustment
      end
      last_weight = weights[key][1]
      last_calories = week[1]
    end
    return tdee.to_f.ceil
  end

  def food_totals day = nil
    day = day.nil? ? current_day : day
    entries = foodentries_from(day)
    totals = {"calories": 0, "fat": 0, "carbs": 0, "protein": 0}
    totals["calories"] = entries.map{|f| f[:calories]}.compact.reduce(0, :+)
    totals["fat"] = entries.map{|f| f[:fat]}.compact.reduce(0, :+)
    totals["carbs"] = entries.map{|f| f[:carbs]}.compact.reduce(0, :+)
    totals["protein"] = entries.map{|f| f[:protein]}.compact.reduce(0, :+)
    return totals
  end

  def foodentries_from day
    foodentries.where(day: day) || foodentries.none
  end

  def weight_average day = nil
    day = day.nil? ? current_day : day
    entries = weightentries_from day
    begin
      average = (entries.map{|e| e["value"]}.compact.reduce(0, :+) / entries.compact.size).to_i || 0
    rescue
      average = 0
    end
    average
  end

  def weight_average_display day = nil, before = ' ', after = ''
    unit_display = before + unit + after
    Unit.new(weight_average(day).to_s + " g").convert_to(unit).scalar.ceil.to_i.to_s + unit_display
  end

  def weightentries_from day
    weightentries.where(day: day) || weightentries.none
  end

end