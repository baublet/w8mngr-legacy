class Food < ActiveRecord::Base
	
	enum food_type: {
		ingredient: 0,
		packaged_food: 1
	}
	
	enum measurement: {
		tsp: 0,
		tbsp: 1,
		cup: 2,
		pint: 3,
		quart: 4,
		gallon: 5,
		ml: 6,
		l: 7,
		gram: 8,
		pound: 9,
		g: 10,
		kg: 11
	}
	
	validates :name, presence: true,
							length: { minimum: 2,  maximum: 155 }

	validates :calories,	presence: true,
							numericality: { only_integer: true, greater_than: 0 }

	validates :amount,		presence: true,
							numericality: { only_integer: true, greater_than: 0 }

	validates :food_type,	presence: true

end
