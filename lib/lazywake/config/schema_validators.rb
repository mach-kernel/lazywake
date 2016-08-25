# frozen_string_literal: true
module Lazywake
  module Config
    module SchemaValidators
      def generated_mappings(data)
        mappings(data)
      end

      def user_mappings(data)
        mappings(data)
      end

      def mappings(data)
        die = ->(why) { raise(ConfigValidationError, why) }
        die.call('Mappings Not Hash') unless data.is_a?(Hash)

        invalid_entries = data.values.select do |x|
          (x =~ /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/).nil?
        end

        die.call('Mappings Invalid MAC') unless invalid_entries.blank?
      end
    end
  end
end
