module JSON
  class Schema
    class MinimumInclusiveAttribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        if data.is_a?(Numeric)
          if (current_schema.schema['minimumCanEqual'] == false ? data <= current_schema.schema['minimum'] : data < current_schema.schema['minimum'])
            message = "The property '#{build_fragment(fragments)}' did not have a minimum value of #{current_schema.schema['minimum']}, "
            message += current_schema.schema['exclusiveMinimum'] ? 'exclusively' : 'inclusively'
            validation_error(processor, message, fragments, current_schema, self, options[:record_errors], { property: last_fragment_as_symbol(fragments), failure: :minimum_inclusive })
          end
        end
      end
    end
  end
end
