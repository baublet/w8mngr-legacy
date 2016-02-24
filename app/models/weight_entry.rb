class WeightEntry < ActiveRecord::Base
    belongs_to :user
                        # We store weights in grams, since they're super granular
                        # These numbers are between 3lbs and about 1,500 lbs
    validates  :value,  presence: true, numericality: { only_integer: true, greater_than: 1359, less_than: 680389 }
    validates  :day,    presence: true,
                        numericality: { only_integer: true, greater_than: 19850501, less_than: 20850501 }
    # Kept in seconds beginning at midnight. So 3,600 = 1am, up to 86,400
    validates  :time_added,   numericality: { only_integer: true, greater_than: 0, less_than: 86400 }

    validates  :user_id,presence: true

    extend WeightManager::DayNavigator

    def update_value new_value, default = "i"
        begin
            new_weight = new_value.to_unit.convert_to("g").scalar.to_i
        rescue
            new_weight = "#{new_value} #{default}".to_unit.convert_to("g").scalar.to_i
        end
        self.value = new_weight
    end

    def display

    end
end
