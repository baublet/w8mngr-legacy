class Food < ActiveRecord::Base

	belongs_to	:user
	validates	:user_id,	presence: true

	validates	:name, presence: true,
							length: { minimum: 2,  maximum: 155 }

	has_many	:measurements, dependent: :destroy
	validates	:measurements, :presence => true
end
