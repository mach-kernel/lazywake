# frozen_string_literal: true
module Lazywake
  module Config
    class Schema
      module Validators
        extend Forwardable

        def_delegator :generated_mappings, :call, :data
        def_delegator :user_mappings, :call, :data

        def mappings(data)
          die = ->(why) { raise(Schema::ConfigValidationError, why) }
          die.call('Mappings Not Hash') unless data.is_a?(Hash)

          invalid_entries = data.values.select do |x|
            (x =~ /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/).nil?
          end

          die.call('Mappings Invalid MAC') unless invalid_entries.blank?
        end
      end
    end
  end
end
