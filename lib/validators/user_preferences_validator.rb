class UserPreferencesValidator < ActiveModel::Validator
  def validate(record)
    validate_date record, "birthday", record.preferences["birthday"]
	validate_height record, "height_display", record.preferences["height_display"]
  end
  
  def validate_date record, attribute, date
	  if !date.blank?
		  begin
			  Chronic.parse(date)
		  rescue
			  record.errors[attribute] << (options[:message] || "is not a valid date")
		  end
	  end
  end
  
  def validate_height record, attribute, unit
	  if !unit.blank?
		  begin
			  unit.to_unit
			  unit.convert_to('cm')
		  rescue
			  record.errors["height"] << (options[:message] || "is not a valid unit of height")
		  end
	  end
  end
end