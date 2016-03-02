class UserPreferencesValidator < ActiveModel::Validator
  def validate record
    validate_date record, "birthday", record.preferences["birthday"]
	validate_height record, "height_display", record.preferences["height_display"]
    validate_name record, "name", record.preferences["name"]
    validate_name record, "height_display", record.preferences["height_display"]
    validate_sex record, "sex", record.preferences["sex"]
    #validate_unit record, "units", record.preferences["units"]
  end

  def validate_unit record, attribute, units
    record.errors[attribute] << (options[:message] || "is an invalid value") if !["i", "m"].include?(units)
  end

  def validate_name record, attribute, name
    return if name.try(:length).nil? || name.blank?
    if name.length > 128
        record.errors[attribute] << (options[:message] || "must be less than 128 characters")
    end
  end

  def validate_sex record, attribute, sex
      record.errors[attribute] << (options[:message] || "is an invalid value") if !["m", "f", "na"].include?(sex)
  end

  def validate_units record, attribute, unit
    return if unit.try(:length).nil? || unit.blank?
    record.errors[attribute] << (options[:message] || "is an invalid value") if !["m", "i"].include?(unit)
  end

  def validate_timezone record, attribute, timezone
      return if timezone.blank?
      if !ActiveSupport::TimeZone[timezone].present?
          record.errors[attribute] << (options[:message] || "is an invalid timezone")
      end
  end

  def validate_date record, attribute, date
      return if date.blank?
	  begin
		  parsed_date = Chronic.parse(date)
	  rescue
		  record.errors[attribute] << (options[:message] || "is not a valid date")
	  end
      if !parsed_date.is_a?(Time)
          record.errors[attribute] << (options[:message] || "is not a valid date")
      end
  end

  def validate_height record, attribute, unit
      return if unit.blank?
	  begin
		  unit.to_unit
		  unit.convert_to('cm')
	  rescue
		  record.errors["height"] << (options[:message] || "is not a valid unit of height")
	  end
  end
end
