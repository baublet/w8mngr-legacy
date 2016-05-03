require 'active_support/concern'

module UserHealthFunctions
  extend ActiveSupport::Concern

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