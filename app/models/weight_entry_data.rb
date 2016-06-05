class WeightEntryData
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
  # depending on the key you pass.
  #
  # Returns an array in the format of [[DateString, ValueString], ...]
  def time_data
    return [] if !valid?

    if length_scope == "day"
      data = WeightEntry.where(user_id: user_id)
                        .group_by_day(:day_ts, default_value: 0, last: num)
                        .average(:value)
                        .to_a
      returndays
    end

    # Group by the weeks
    if length_scope == "week"
      weeks = WeightEntry.where(user_id: user_id)
                        .group_by_week(:day_ts, default_value: 0, last: num)
                        .average(:value)
                        .to_a
      return weeks
    end

    # Group by months
    if length_scope == "month"
      months = WeightEntry.where(user_id: user_id)
                          .group_by_month(:day_ts, default_value: 0, last: num)
                          .average(:value)
                        .to_a
      return months
    end

    # Group by year
    if length_scope == "year"
      data = WeightEntry.where(user_id: user_id)
                        .group_by_year(:day_ts, default_value: 0, last: num)
                        .average(:value)
                        .to_a
      return data
    end

  end

end