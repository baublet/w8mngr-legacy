module WeightManager
  module DayNavigator
    def self.today
      where(day: Time.current.strftime('%Y%m%d').to_i)
    end

    def self.current_day
      where(day: current_day.to_i)
    end

    def self.from_day day
      where(day: day)
    end

    # This transforms the day integer to a timestamp in our database so that we
    # can access the day_ts in charting and progress
    extend ActiveSupport::Concern
    included do
      before_save :set_day_ts
      before_create :set_day_ts
    end

    def set_day_ts
      self.day_ts = DateTime.strptime(day.to_s,"%Y%m%d")
    end
  end
end
