# frozen_string_literal: true
module Lazywake
  # rubocop:disable Style/MethodMissing
  module Config
    extend ActiveSupport::Autoload
    extend Forwardable

    autoload :Schema
    autoload :Wrapper

    %i(save load respond_to_missing).each do |m|
      def_delegator Wrapper, m, "self.#{m}"
    end

    def self.method_missing(key, *args)
      return super unless Schema::CONFIG_SCHEMA.key?(key)
      Wrapper.data.fetch(key)
    end
  end
  # rubocop:enable Style/MethodMissing
end
