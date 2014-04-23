module JSON
  class Schema
    class MinItemsAttribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        if data.is_a?(Array) && (data.compact.size < current_schema.schema['minItems'])
          message = "The property '#{build_fragment(fragments)}' did not contain a minimum number of items #{current_schema.schema['minItems']}"
          validation_error(processor, message, fragments, current_schema, self, options[:record_errors], { property: last_fragment_as_symbol(fragments), failure: :min_items })
        end
      end
    end
  end
end
