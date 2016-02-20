class DateValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		begin
			Time.parse(value)
			return true
		rescue
			record.errors[attribute] << (options[:message] || "is not a valid date")
		end
	end
end