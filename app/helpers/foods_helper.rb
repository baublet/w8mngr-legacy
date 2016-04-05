module FoodsHelper

    # Increments the popularity of food_id and measurement_id by 1
    # Fails silently if one or the other can't be found
    def increment_popularity food_id, measurement_id
        Food.increment_counter(:popularity, food_id.to_i)
        Measurement.increment_counter(:popularity, measurement_id.to_i)
    end

end
