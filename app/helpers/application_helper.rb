require 'date'

module ApplicationHelper

    # Returns the page's full title
    def full_title(page_title = '')
        base_title = "w8mngr"
        if page_title.empty?
            base_title + " | The Lifestyle Tracker"
        else
            page_title + " | " + base_title
        end
    end

    # Returns the current day in our DB's day storage format (YYYYMMDD)
    def current_day
        if @current_day.nil?
            # Here, I want a date range between 1985 and 2085. If I get to be
            # 100 years old, surely someone can change this line for me...
            passed_day = params[:day]|| params[:food_entry][:day]
            if passed_day.nil? || passed_day.to_i < 19850501 || passed_day.to_i > 20850501
                passed_day = Date.today.strftime('%Y%m%d')
            end
            @current_day = passed_day
        end
        return @current_day
    end

    # Returns the previous day in our DB's day storage format
    def previous_day
        if @previous_day.nil?
            @previous_day = convert_day_to_date(current_day).yesterday.strftime('%Y%m%d')
        end
        return @previous_day
    end

    def next_day
        if @next_day.nil?
            @next_day = convert_day_to_date(current_day).tomorrow.strftime('%Y%m%d')
        end
        return @next_day
    end

    private

    # Converts YYYYMMDD to a Date object
    def convert_day_to_date(string)
        return Date.strptime(string,"%Y%m%d")
    end
end
