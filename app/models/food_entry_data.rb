class FoodEntryData
  include ActiveModel::Model

  attr_accessor(
    :user_id,
    :length_scope,
    :num
  )

  validates :user_id,       presence: true
  validates :num,           presence: true,
                        numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :length_scope,  presence: true,
                           inclusion: { in: %w(day week month year),
                             message: "%{value} is not a valid size" }

  # Returns a series of data by either days, weeks, months, or years
  # depending on the key you pass. It then groups all of the user's
  # entries by days (adding them all up), and then further groups them
  # based on the column. If anything other than days, it averages the
  # days in the designated grouping (week, month, year) and returns
  # a much smaller hash.
  #
  # Returns a hash.
  #
  # Params:
  # +column+:: column you wish to return data from. Values: +:calories, :fat,
  #            :carbs, :protein+. Default: +:calories+
  def time_data column = "calories"
    return {} if !valid?
    return {} if !["calories", "fat", "carbs", "protein"].include?(column)

    scope_multiplier = 1
    scope_multiplier = length_scope == "week" ? 7 : scope_multiplier
    scope_multiplier = length_scope == "month" ? 30 : scope_multiplier
    scope_multiplier = length_scope == "year" ? 360 : scope_multiplier

    length = num.to_i
    last = length * scope_multiplier

    # First, we get the days
    days = FoodEntry.where(user_id: user_id).group_by_day(:day_ts, default_value: nil, last: last).sum(column)
    days = days.select {|k,v| true if !v.nil?}
    return days if length_scope == "day"

    # Group by the weeks
    if length_scope == "week"
      weeks = days.group_by_week() { |d| d[0] }
      return Hash[weeks.map { |k,v| [k, v.map(&:last).inject(:+) / v.size] rescue [k, 0] }]
    end

    # Group by months
    if length_scope == "month"
      months = days.group_by_month { |d| d[0] }
      return Hash[months.map { |k,v| [k, v.map(&:last).inject(:+) / v.size] rescue [k, 0] }]
    end

    # Group by year
    if length_scope == "year"
      years = days.group_by_year { |d| d[0] }
      return Hash[years.map { |k,v| [k, v.map(&:last).inject(:+) / v.size] rescue [k, 0] }]
    end

    return {}
  end

end