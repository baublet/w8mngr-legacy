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

    def display_value before = ' ', after = ''
      return "" if value.nil?
      unit_display = before + user.unit + after
      Unit.new(value.to_s + " g").convert_to(user.unit).scalar.ceil.to_i.to_s + unit_display
    end
end
