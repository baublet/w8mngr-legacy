class OptionValue < ActiveRecord::Base
    belongs_to :user
    belongs_to :option

    before_save { validate_type }

    def validate_type
        valid_value Option.find_by_id(self.option_id), self.value
    end

    def valid_value option, value
        case option.kind
        # This won't save anyway, because it means the option wasn't setup
        when nil
            false
        # Boolean
        when "b"
            ["true", "false"].include? value.downcase
        # String field or textarea, always true
        when "s", "t"
            true
        # Number field, only numbers allowed
        when "n", "i", "f"
            true if Float(value) rescue false
        # Options with specific values
        when "o"
            if option.values.blank?
                return false
            end
            allowed_values = option.values.split("\n")
            allowed_values.each do |allowed_value|
                pairs = allowed_value.split(":")
                if pairs[0].squish == value.downcase.squish
                    return true
                end
            end
            return false
        else
            # Unknown type, raise an exception
            raise Exception.new("Unknown option type!")
        end
    end
end
