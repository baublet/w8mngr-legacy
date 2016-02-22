module DayNavigator
    def self.today
        where(day: Time.current.strftime('%Y%m%d').to_i)
    end

    def self.current_day
        where(day: current_day.to_i)
    end

    def self.day day
        where(day: day)
    end
end
