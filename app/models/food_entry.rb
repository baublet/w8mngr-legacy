class FoodEntry < ActiveRecord::Base
	belongs_to :user

	validates :description, presence: true,
					 		length: { minimum: 2,  maximum: 155 }

	validates :calories,	presence: true,
							numericality: { only_integer: true, greater_than: 0 }

	validates :day,			presence: true,
							numericality: { only_integer: true, greater_than: 19850501, less_than: 20850501 }

	validates :user_id,		presence: true
end
