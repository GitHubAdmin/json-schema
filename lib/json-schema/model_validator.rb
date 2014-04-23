module JSON

  class ModelValidator

    attr_reader :schema

    DYNAMIC_VALIDATORS = [
                          [ [ 'requiredIf', :requiredIf ], :process_required_if ],
                          [ [ 'noneOfTheAbove', :noneOfTheAbove ], :process_none_of_the_above ]
                         ]

    def initialize(schema)
      if schema.is_a?(String)
        @schema = JSON.parse(File.new(schema).read)
      elsif schema.is_a?(Hash)
        @schema = schema
      else
        raise "Schema must be a path or a hash!"
      end
    end

    #
    # Validate the specified model having the hash data contained
    # in the hash_attribute attribute. By default the hash data
    # is assumed to be located in the model's 'responses' 
    # attribute.
    #
    def validate(model, hash_attribute=:responses)
      data = model[hash_attribute] || {}
      
      # Put the hash data into an OpenStruct to allow access to
      # the hash data as an object. We're using the short variable
      # name of 'r' because that's what we're using in the schema
      # definition; it keeps the schema stuff short and to the point.
      r = OpenStruct.new(data)

      # Do the static validation first
      errors = JSON::Validator.fully_validate(schema, data, errors_as_objects: true).map { | e | e[:error_details] }.uniq

      # Now perform dynamic validation
      schema['properties'].each_pair do | property, sch |
        errors.concat process_dynamic_validation(property, sch, r)
      end

      # Add the errors to the model
      errors.each do | error |
        model.errors.add(error[:property], stringize_error(error))
      end

      errors
    end

    def stringize_error(error)
      s = "#{error[:property]}_#{error[:failure]}"
      defined?(I18n) ? I18n.t(s) : s
    end

    def process_dynamic_validation(property, sch, r)
      errors = []
      DYNAMIC_VALIDATORS.each do | dv |
        dv_value = sch[dv.first.first] || sch[dv.first.last]
        error = send(dv.last, r, property, dv_value) if dv_value.present?
        errors << error if error.present?
      end
      errors
    end

    def process_required_if(r, property, required_if_expression)
      if eval(required_if_expression)
        { property: property.to_sym, failure: :required } if r[property.to_sym].blank?
      end
    end

    def process_none_of_the_above(r, property, none_of_the_above_value)
      value = r[property.to_sym]
      if value.is_a?(Array)
        { property: property.to_sym, failure: :noneOfTheAbove } if value.include?(none_of_the_above_value) && value.size > 1
      end
    end

  end

end
