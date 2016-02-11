class Measurement < ActiveRecord::Base
  belongs_to :food
  
  validates	:amount, presence: true
  validates	:unit, presence: true
  validates	:calories, presence: true
  validates	:fat, presence: true
  validates	:carbs, presence: true
  validates	:protein, presence: true
end
