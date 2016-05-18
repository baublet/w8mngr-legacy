class FoodEntryChart
  include ActiveModel::Model

  attr_accessor(
    :user_id,
    :scope,
    :start,
    :end
  )

  validates :user_id, presence: true
  validates :start,   presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :end,     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: :start }
  validates :scope,   presence: true, inclusion: { in: %w(day week month year),
                                      message: "%{value} is not a valid size" }

  def line_chart
    false if !valid?
    FoodEntry.where(user_id: user_id).group_by_day(:day_ts)
  end

end