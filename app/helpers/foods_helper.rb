module FoodsHelper

    # Increments the popularity of food_id and measurement_id by 1
    # Try not to only mass one. This function works if you pass nil to one
    # or the other, but our models have built-in functions to handle this
    # if you need to increment a single one (or, if you just know the ID,
    # use the functions below that ActiveRecord provides)
    def increment_popularity food_id, measurement_id
        Food.increment_counter(:popularity, food_id.to_i) unless food_id.nil?
        Measurement.increment_counter(:popularity, measurement_id.to_i) unless measurement_id.nil?
    end

end
