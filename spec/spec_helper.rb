# frozen_string_literal: true
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'active_support'
require 'active_support/core_ext'
require 'lazywake'
require 'pry'
require 'rspec'

include Lazywake
