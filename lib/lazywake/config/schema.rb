# frozen_string_literal: true
module Lazywake
  module Config
    class Schema
      extend ActiveSupport::Autoload
      autoload :Validators
      include Validators

      class ConfigValidationError < StandardError; end

      CONFIG_SCHEMA = {
        lazywake_version: Lazywake::VERSION,
        generated_mappings: {},
        user_mappings: {}
      }.with_indifferent_access.freeze

      def self.validate(schema)
        new.validate(schema)
      end

      def validate(schema)
        raise(
          ConfigValidationError, 'Invalid Base Object'
        ) unless schema.is_a?(Hash)
        schema.each_pair { |k, v| send(k, v) }
      end

      # Just assert type for fields that do not have their own
      # validator
      def method_missing(key, *args)
        return super unless CONFIG_SCHEMA.key?(key)
        raise(
          ConfigValidationError,
          "#{key} is incorrectly defined"
        ) if CONFIG_SCHEMA[key].class != args.first.class
      end

      def respond_to_missing?(key, respond_private = false)
        CONFIG_SCHEMA.key?(key) || super
      end
    end
  end
end
