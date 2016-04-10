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

  include PgSearch
  pg_search_scope :search_foods,
                      :against => {
                          :name => 'A',
                          :description => 'B'
                      },
                      :using => {
                          :tsearch => {
                              :prefix => true,
                              :negation => true,
                              :dictionary => "english"
                          }
                      }

  # Load the results passed from the USDA API into this object
  def populate_from_usda result

    # Loop through the nutrients and build our measurements
    new_measurements = {}
    result["nutrients"][0]["measures"].each do |measure|
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
        new_measurements[measure["label"]]["calories"] += measure["value"].to_i
    end

    # Fat (always [3])
    result["nutrients"][3]["measures"].each do |measure|
        new_measurements[measure["label"]]["fat"] += measure["value"].to_i
    end

    # Carbs (always [4])
    result["nutrients"][4]["measures"].each do |measure|
        new_measurements[measure["label"]]["carbs"] += measure["value"].to_i
    end

    # Protein (always [2])
    result["nutrients"][2]["measures"].each do |measure|
        new_measurements[measure["label"]]["protein"] += measure["value"].to_i
    end

    new_measurements.each do |measurement|
        self.measurements.new(measurement.second)
    end
  end

end
