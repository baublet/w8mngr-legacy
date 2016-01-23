class FoodEntry < ActiveRecord::Base
	validates :description, presence: true,
					 		length: { minimum: 2 }
	validates :calories,	presence: true,
							numericality: { only_integer: true, greater_than: 0 }
end
