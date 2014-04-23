module JSON
  class Schema
    class PatternAttribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        if data.is_a?(String)
          r = Regexp.new(current_schema.schema['pattern'])
          if (r.match(data)).nil?
            message = "The property '#{build_fragment(fragments)}' value #{data.inspect} did not match the regex '#{current_schema.schema['pattern']}'"
            validation_error(processor, message, fragments, current_schema, self, options[:record_errors], { property: last_fragment_as_symbol(fragments), failure: :pattern })
          end
        end
      end
    end
  end
end
