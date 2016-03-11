class Ingredient < ActiveRecord::Base
  after_initialize :load_food_measurement_data

  belongs_to  :recipe,       inverse_of: :ingredients
  validates   :name,       length: { minimum: 8,  maximum: 155 },
                            if: "measurement_id.nil?"
  validates   :calories,    presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                            if: "measurement_id.nil?"
  validates   :fat,         presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                            if: "measurement_id.nil?"
  validates   :carbs,       presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                            if: "measurement_id.nil?"
  validates   :protein,     presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                            if: "measurement_id.nil?"

  # This validation first looks if the ingredient itself has fields,
  # if it doesn't, it looks fora measurement ID to be valid. If it's not,
  # it then tells them to enter the proper fields
  validate :measurement_must_be_valid_if_not_nil

  private

  def load_food_measurement_data
    # No need to do this if the food measurement_id is nil
    if !measurement_id.nil?
      measurement = Measurement.find(measurement_id)
      self.name = measurement.amount + " " + measurement.unit + ","
      self.name = name + " " + measurement.food.name
      self.calories = measurement.calories
      self.carbs = measurement.carbs
      self.fat = measurement.fat
      self.protein = measurement.protein
    end
  end

  def measurement_must_be_valid_if_not_nil
    if !measurement_id.nil?
      begin
        measurement = Measurement.find(measurement_id)
      rescue
      end
      #puts measurement
      if measurement.nil?
        errors.add(:name, "You must fully enter the name, calories, fat, carbs, and protein of your ingredient")
      end
    end
  end

end
