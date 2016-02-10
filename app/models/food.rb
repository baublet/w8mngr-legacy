class Food < ActiveRecord::Base

	belongs_to	:user
	validates	:user_id,	presence: true

	enum public: {
		priv:	0,
		pub:	1
	}

	enum food_type: {
		common_food: 0,
		packaged_food: 1
	}

	enum measurement: {
		na: 12,
		tsp: 0,
		tbsp: 1,
		cup: 2,
		pint: 3,
		quart: 4,
		gallon: 5,
		ml: 6,
		l: 7,
		oz: 13,
		pound: 9,
		gram: 8,
		kilo: 11
	}

	validates :name, presence: true,
							length: { minimum: 2,  maximum: 155 }

	validates :calories,	presence: true,
							numericality: { only_integer: true, greater_than: 0 }

	validates :food_type,	presence: true

end
