# frozen_string_literal: true
require 'pry'

module Lazywake
  module Config
    class Schema
      include SchemaValidators

      class ConfigValidationError < StandardError; end

      CONFIG_SCHEMA = {
        lazywake_version: Lazywake::VERSION,
        generated_mappings: {},
        user_mappings: {}
      }.freeze

      def valid?(schema)
        raise ConfigValidationError, 'Invalid JSON' unless schema.is_a?(Hash)
        schema.each_pair { |k, v| send(k, v) }
        true
      end

      # Just assert type for fields that do not have their own
      # validator
      def method_missing(key, *args, &block)
        # If there is anything extra, we won't throw a fit.
        if CONFIG_SCHEMA.key?(key)
          raise(
            ConfigValidationError,
            "#{key} is incorrectly defined"
          ) if CONFIG_SCHEMA[key].class != args.first.class
        else super
        end
      end

      def respond_to_missing?(key, respond_private = false)
        CONFIG_SCHEMA.key?(key) || super
      end
    end
  end
end
