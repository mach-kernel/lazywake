# frozen_string_literal: true
require 'json'

module Lazywake
  module Config
    # rubocop:disable Style/ClassVars
    class Wrapper
      cattr_reader :data

      def self.load(path)
        die = ->(why) { raise(Schema::ConfigValidationError, why) }
        die.call('Config file not found') unless File.exist?(path)

        @@data = begin
          pre_data = JSON.parse(File.read(path)).with_indifferent_access
          die.call('Failed config validation') unless Schema.valid?(pre_data)
          pre_data
        rescue JSON::JSONError
          die.call('Invalid JSON in config file')
        ensure nil
        end
      end

      # TODO: Doing this to clean for tests, maybe useless?
      def self.reset
        @@data = nil
      end
    end
    # rubocop:enable Style/ClassVars
  end
end
