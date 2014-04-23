module JSON
  class Schema
    class MinLengthAttribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        if data.is_a?(String)
          if data.length < current_schema.schema['minLength']
            message = "The property '#{build_fragment(fragments)}' was not of a minimum string length of #{current_schema.schema['minLength']}"
            validation_error(processor, message, fragments, current_schema, self, options[:record_errors], { property: last_fragment_as_symbol(fragments), failure: :min_length })
          end
        end
      end
    end
  end
end
