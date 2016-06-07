class WeightEntry < ActiveRecord::Base
    belongs_to :user,   inverse_of: :weightentries
                        # We store weights in grams, since they're super granular
                        # These numbers are between 3lbs and about 1,500 lbs
    validates  :value,  presence: true, numericality: { only_integer: true, greater_than: 1359, less_than: 680390 }
    validates  :day,    presence: true,
                        numericality: { only_integer: true, greater_than: 19850501, less_than: 20850501 }

    validates  :user_id,presence: true

    extend WeightManager::DayNavigator

    def update_value new_value
      begin
          new_weight = new_value.to_unit.convert_to("g").scalar.to_i
      rescue
        begin
          new_weight = "#{new_value} #{user.unit}".to_unit.convert_to("g").scalar.to_i
        rescue
          new_weight = 0
        end
      end
      self.value = new_weight
    end

    def display_value
      WeightEntry.get_display_value value, user.unit
    end

    def self.get_display_value number, unit
      return nil if number.nil? || unit.nil?
      Unit.new(number.to_s + " g").convert_to(unit).scalar.ceil.to_i
    end

end
