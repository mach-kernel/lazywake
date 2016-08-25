# frozen_string_literal: true
require 'active_support'
require 'active_support/core_ext'

module Lazywake
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Plugins
  autoload :VERSION
end
