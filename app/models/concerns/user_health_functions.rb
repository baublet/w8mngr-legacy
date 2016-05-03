require 'active_support/concern'

module UserHealthFunctions
  extend ActiveSupport::Concern

  def recent_most_weight
    weightentries.last
  end

  # Returns nil if there isn't enough information about the user to make a calculation
  def bmr

    # Convert the recent rate from G to LBs
    recent_weight = self.recent_most_weight.value.to_s + "g"
    recent_weight = recent_weight.to_unit.convert_to("lbs").scalar.to_i

    user_age = self.age

    # Require at least these parameters before being able to calculate BMR
    return nil if preferences["height"].blank? || user_age.nil? || recent_weight.nil?

    # If there's no sex stated, assume the person is female (because it estimates lower)
    sex = preferences["sex"] == "m" ? "m" : "f"

    # Our activity levels correspond to a percentage above
    activity = preferences["activity_level"].blank? ? 2 : preferences["activity_level"]
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

  def food_totals day = nil
    day = day.nil? ? current_day : day
    entries = foodentries_from(day)
    totals = {calories: 0, fat: 0, carbs: 0, protein: 0}
    totals["calories"] = entries.map{|f| f["calories"]}.compact.reduce(0, :+)
    totals["fat"] = entries.map{|f| f["fat"]}.compact.reduce(0, :+)
    totals["carbs"] = entries.map{|f| f["carbs"]}.compact.reduce(0, :+)
    totals["protein"] = entries.map{|f| f["protein"]}.compact.reduce(0, :+)
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