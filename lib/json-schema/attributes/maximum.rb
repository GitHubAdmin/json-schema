module JSON
  class Schema
    class MaximumAttribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        if data.is_a?(Numeric)
          if (current_schema.schema['exclusiveMaximum'] ? data >= current_schema.schema['maximum'] : data > current_schema.schema['maximum'])
            message = "The property '#{build_fragment(fragments)}' did not have a maximum value of #{current_schema.schema['maximum']}, "
            message += current_schema.schema['exclusiveMaximum'] ? 'exclusively' : 'inclusively'
            validation_error(processor, message, fragments, current_schema, self, options[:record_errors], { property: last_fragment_as_symbol(fragments), failure: :maximum })
          end
        end
      end
    end
  end
end
