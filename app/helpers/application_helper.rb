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
            passed_day =    params.try(:[], :food_entry).try(:[], :day) ||
                            params.try(:[], :weight_entry).try(:[], :day) ||
                            params.try(:[], :day)
            #passed_day = ((params[:food_entry].nil?)? nil : params[:food_entry][:day]) ||
            #             ((params[:weight_entry].nil?)? nil : params[:weight_entry][:day]) ||
            #             params[:day]
            # Here, I want a date range between 1985 and 2085. If I get to be
            # 100 years old, surely someone can change this line for me...
            if passed_day.nil? || passed_day.to_i < 19850501 || passed_day.to_i > 20850501
                passed_day = Time.current.strftime('%Y%m%d')
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

    # Returns the next day in our DB's day storage format
    def next_day
        if @next_day.nil?
            @next_day = convert_day_to_date(current_day).tomorrow.strftime('%Y%m%d')
        end
        @next_day
    end

    # Converts YYYYMMDD to a Date object
    def convert_day_to_date string
        Date.strptime(string.to_s,"%Y%m%d")
    end

    # Converts YYYYMMDD into a nice looking date (Saturday, January 1, 2010)
    def nice_day string
        convert_day_to_date(string).strftime('%A, %B %e, %Y')
    end

    # Validates a YYYYMMDD string, returning current_day if it's false
    def validate_day day_string
        day_int = day_string.to_i
        if day_int > 19850501 && day_int < 20850501
            return day_string
        else
            return current_day
        end
    end

    # This helper checks if we're using a manifest for loading webpack files, if we are, it will look it up, otherwise, it will use the standard bundle filename
    def webpack_bundle_tag(bundle)
      src =
        if Rails.configuration.webpack[:use_manifest]
          manifest = Rails.configuration.webpack[:asset_manifest]
          filename = manifest[bundle]

          "#{compute_asset_host}/assets/#{filename}"
        else
          "#{compute_asset_host}/assets/#{bundle}-bundle"
        end

      javascript_include_tag(src)
    end

    def webpack_manifest_script
      return '' unless Rails.configuration.webpack[:use_manifest]
      javascript_tag "window.webpackManifest = #{Rails.configuration.webpack[:common_manifest]}"
    end
end
