class UnitValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		begin
            value.to_unit
        rescue
            record.errors[attribute] << (options[:message] || "is not a unit")
        end
	end
end