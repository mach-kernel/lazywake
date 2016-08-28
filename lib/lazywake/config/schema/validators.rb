# frozen_string_literal: true
module Lazywake
  module Config
    class Schema
      module Validators
        extend Forwardable

        def mappings(data)
          die = ->(why) { raise(Schema::ConfigValidationError, why) }
          die.call('Mappings Not Hash') unless data.is_a?(Hash)

          invalid_entries = data.values.select do |x|
            (x =~ /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/).nil?
          end

          die.call('Mappings Invalid MAC') unless invalid_entries.blank?
        end
        alias generated_mappings mappings
        alias user_mappings mappings
      end
    end
  end
end
