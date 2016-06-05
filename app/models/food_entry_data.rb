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
  # Returns an array in the form of [[DateString, ValueString], ...]
  #
  # Params:
  # +column+:: column you wish to return data from. Values: +calories+, +fat+,
  #            +carbs+, +protein+. Default: +calories+
  def time_data column = "calories"
    return [] if !valid?
    return [] if !["calories", "fat", "carbs", "protein"].include?(column)

    scope_multiplier = 1
    scope_multiplier = length_scope == "week" ? 7 : scope_multiplier
    scope_multiplier = length_scope == "month" ? 30 : scope_multiplier
    scope_multiplier = length_scope == "year" ? 360 : scope_multiplier

    length = num.to_i
    last = length * scope_multiplier

    # First, we get the days
    days = FoodEntry.where(user_id: user_id)
                    .group_by_day(:day_ts, default_value: 0, last: last)
                    .sum(column)
                    .to_a
    return days if length_scope == "day"

    # Group by the weeks
    if length_scope == "week"
      weeks = days.group_by_week() { |d| d[0] }
      return average_of weeks
    end

    # Group by months
    if length_scope == "month"
      months = days.group_by_month { |d| d[0] }
      return average_of months
    end

    # Group by year
    if length_scope == "year"
      years = days.group_by_year { |d| d[0] }
      return average_of years
    end

    return []
  end

  def average_of data
    return data.map { |k,v|
      begin
        # First, find out how many non-zero entries there are to we can get an
        # accurate average
        good_days = v.select { |e| e[1] > 0 }
        total_days = good_days.count
        [k, nil] if total_days < 1
        [k, v.map(&:last).inject(:+) / total_days]
      rescue
        [k, nil]
      end
    }
  end

end