class Measurement < ActiveRecord::Base
    
    # So that they're always sorted by popularity
    default_scope {
                order("popularity DESC")
            }
    
    belongs_to  :food

    validates	:amount,  presence: true, length: { minimum: 1,  maximum: 10 }
    validates	:unit,    presence: true
    validates	:calories,presence: true
    validates	:fat,     presence: true
    validates	:carbs,   presence: true
    validates	:protein, presence: true
end
