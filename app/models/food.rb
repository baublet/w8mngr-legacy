class Food < ActiveRecord::Base
  # So that they're always sorted by popularity
  default_scope {
    where(deleted: false)
  }

  belongs_to   :user,         inverse_of: :foods
  validates    :user_id,	    presence: true

  validates    :name,         presence: true,
                              length: { minimum: 2,  maximum: 155 }

  has_many     :measurements, dependent: :destroy, inverse_of: :food
  validates    :measurements, :presence => true

  # The food search uses this attribute to tell the frontend how to render the
  # food (it will vary by data source)
  attr_accessor  :data_source

  # Sets the data_source default to be local
  def data_source
    @data_source || "local"
  end

  include PgSearch
  pg_search_scope :search_foods,
                      :against => {
                          :name => 'A',
                          :description => 'B'
                      },
                      :ranked_by => "(popularity * 0.1) + :tsearch",
                      :using => {
                          :tsearch => {
                              :prefix => true,
                              :negation => true,
                              :dictionary => "english"
                          }
                      }
  pg_search_scope :autocomplete_foods,
                      :against => {
                          :name => 'A',
                          :description => 'B'
                      },
                      :ranked_by => "popularity + :tsearch",
                      :using => {
                          :tsearch => {
                              :prefix => true,
                              :negation => true,
                              :dictionary => "english"
                          }
                      }

  def increment_popularity
    self.popularity = self.popularity + 1
    save()
  end

  # Pass in a hash of measurements in the form of [measurement_id][elements]
  # Returns an error message if one or more of the measurements could not be
  # updated/deleted. Otherwise, returns false
  def update_measurements measurements
    return "No measurements passed." unless measurements.is_a?(Hash)
    measurements.each do |id, measurement_data|
      id = id.to_i
      # Skip the ID 0, which is our "new measurement" box
      next if id == 0
      measurement_index = self.measurements.index { |m| m if m.id == id }
      measurement = measurement_index.nil? ? nil : self.measurements[measurement_index]
      return "Measurement not found on the food." if measurement.nil?
      if measurement_data[:delete] == "yes"
        return "Foods need at least one measurement." if self.measurements.count == 1
        measurement.destroy
        next
      end
      # We need to do it this way so strong params doesn't trigger an exception
      measurement.amount = measurement_data[:amount]
      measurement.unit = measurement_data[:unit]
      measurement.calories = measurement_data[:calories]
      measurement.fat = measurement_data[:fat]
      measurement.carbs = measurement_data[:carbs]
      measurement.protein = measurement_data[:protein]
      return "One or more of your measurements failed to update." unless measurement.save
    end
    return true
  end

  # Load the results passed from the USDA API into this object
  def populate_from_usda result

    # Loop through the nutrients and build our measurements
    new_measurements = {}
    result["nutrients"][0]["measures"].each do |measure|
      next if measure.nil?
      new_measurements[measure["label"]] = {
          "unit" => measure["label"],
          "amount" => measure["qty"],
          "calories" => 0,
          "fat" => 0,
          "carbs" => 0,
          "protein" => 0
      }
    end

    # Calories (always [1])
    result["nutrients"][1]["measures"].each do |measure|
      next if measure.nil?
      new_measurements[measure["label"]]["calories"] += measure["value"].to_i
    end

    # Fat (always [3])
    result["nutrients"][3]["measures"].each do |measure|
      next if measure.nil?
      new_measurements[measure["label"]]["fat"] += measure["value"].to_i
    end

    # Carbs (always [4])
    result["nutrients"][4]["measures"].each do |measure|
      next if measure.nil?
      new_measurements[measure["label"]]["carbs"] += measure["value"].to_i
    end

    # Protein (always [2])
    result["nutrients"][2]["measures"].each do |measure|
      next if measure.nil?
      new_measurements[measure["label"]]["protein"] += measure["value"].to_i
    end

    new_measurements.each do |measurement|
      self.measurements.new(measurement.second)
    end
  end

end
