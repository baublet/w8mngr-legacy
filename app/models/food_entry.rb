class FoodEntry < ActiveRecord::Base
	belongs_to :user,       inverse_of: :foodentries

	validates :description, presence: true, length: { minimum: 2,  maximum: 155 }
	validates :calories,    presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
	validates :day,         presence: true, numericality: { only_integer: true, greater_than: 19850501, less_than: 20850501 }
	validates :user_id,     presence: true

	extend WeightManager::DayNavigator

	# Pass a measurement ID and multiplier to this object and it populates this food entry with the food's data, multiplied by the multiplier, for adding foods to users' food logs
	# Example useage:
	# 	@food_entry = current_user.foodentries.build(day: @day).populate_with_food(measurement_id, multiplier)
	def populate_with_food measurement_id, multiplier
		measurement = Measurement.find(measurement_id.to_i)
		if !measurement.nil?
			# This should never fail given how we structured our models
			food = measurement.food
			begin
				multiplier = multiplier.to_r.to_f
			rescue
				multiplier = 1
			end
			multiplier = 1 if multiplier == 0
			description = "#{(multiplier * measurement.amount.to_i).to_s} #{measurement.unit} " + food.name
			calories = measurement.calories * multiplier
			fat = measurement.fat * multiplier
			carbs = measurement.carbs * multiplier
			protein = measurement.protein * multiplier

			self.description = description
			self.calories = calories.to_i
			self.fat = fat.to_i
			self.carbs = carbs.to_i
			self.protein = protein.to_i
		end
		return self
	end

	def as_json(options={})
		super(:only => [:id, :description, :calories, :fat, :carbs, :protein])
	end
end
