# frozen_string_literal: true
require 'active_support'
require 'active_support/core_ext'

module Lazywake
  extend ActiveSupport::Autoload

  autoload :Command
  autoload :Config
  autoload :Network
  autoload :VERSION
end
