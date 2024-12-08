class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || (blank?(value) && !options[:presence])

    date_validations(record, attribute, value) if record.errors.attribute_names.exclude?(attribute)
  end

  def date_validations(record, attribute, value)
    if options[:after_or_equal_to] && !after_or_equal_to?(
      record, value, options[:after_or_equal_to]
    )
      record.errors.add(attribute, :after_or_equal_to, attribute:,
                                                       compared_attribute: options[:after_or_equal_to])
    end
  end

  private

  def blank?(value)
    return false if value.is_a?(Date) || value.is_a?(DateTime) || value.is_a?(ActiveSupport::TimeWithZone)

    date_fields = %i[day month year]
    date_fields -= [:day] if options[:month_and_year]

    value.to_h.slice(*date_fields).all? { |_, v| v.blank? }
  end

  def after_or_equal_to?(record, value, field_to_compare)
    value_to_compare = record.send(field_to_compare)
    unless value_to_compare.is_a?(Date) || value_to_compare.is_a?(DateTime) || value_to_compare.is_a?(ActiveSupport::TimeWithZone)
      return true
    end

    value_to_compare < value
  end
end
