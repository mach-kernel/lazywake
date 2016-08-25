# frozen_string_literal: true
module Lazywake
  module Config
    extend ActiveSupport::Autoload

    autoload :Schema
    autoload :SchemaValidators
  end
end
