# frozen_string_literal: true
module Lazywake
  # rubocop:disable Style/MethodMissing
  module Config
    extend ActiveSupport::Autoload
    extend Forwardable

    autoload :Schema
    autoload :Wrapper

    def_delegator Wrapper, :load, 'self.load'
    def_delegator Wrapper, :respond_to_missing, 'self.respond_to_missing'

    def self.method_missing(key, *args)
      return super unless Schema::CONFIG_SCHEMA.key?(key)
      Wrapper.data.fetch(key)
    end
  end
  # rubocop:enable Style/MethodMissing
end
