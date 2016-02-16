module MeasurementsHelper
    def verbose_measurement_unit measurement
        measurements = {
            "c"     => "cup",
            "cp"    => "cup",
            "cs"    => "cups",
            "cps"   => "cups",
            "g"     => "gram",
            "gs"    => "grams",
            "kg"    => "kilogram",
            "kgs"   => "kilograms",
            "oz"    => "ounce",
            "ozs"   => "ounces",
            "lb"    => "pound",
            "lbs"   => "pounds",
            "tsp"   => "teaspoon",
            "tspns" => "teaspoons",
            "tbspn" => "tablespoon",
            "tbsp"  => "tablespoon",
            "tbspns"=> "tablespoons",
            "tbsps" => "tablespoons"
        }
        measurement = measurement.downcase
        return measurements[measurement] || measurement
    end
end
