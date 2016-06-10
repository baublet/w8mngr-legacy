class Measurement < ActiveRecord::Base

  # So that they're always sorted by popularity
  # I know this is generally considered poor form, but it works for this case,
  # since we never really sort measurements in any other way
  default_scope {
    order("popularity DESC")
  }

  belongs_to  :food,  inverse_of: :measurements

  validates   :amount,  presence: true, length: { minimum: 1,  maximum: 10 }
  validates   :unit,    presence: true
  validates   :calories,presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates   :fat,     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates   :carbs,   presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates   :protein, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def increment_popularity
    self.popularity = self.popularity + 1
    save()
  end
end
