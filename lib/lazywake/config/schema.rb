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
      }.freeze

      def self.valid?(schema)
        new.valid?(schema)
      end

      def valid?(schema)
        raise(
          ConfigValidationError, 'Invalid Base Object'
        ) unless schema.is_a?(Hash)

        schema.each_pair { |k, v| send(k, v) }
        true
      end

      # Just assert type for fields that do not have their own
      # validator
      def method_missing(key, *args)
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
