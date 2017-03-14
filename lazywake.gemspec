# -*- encoding: utf-8 -*-
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazywake/version'

Gem::Specification.new do |gem|
  gem.name          = 'lazywake'
  gem.version       = Lazywake::VERSION
  gem.summary       = 'Better wakeonlan replacement that intuitively uses your'\
  ' ARP table to cache hostnames.'
  gem.description   = 'Description'
  gem.license       = 'MIT'
  gem.authors       = ['David Stancu']
  gem.email         = 'dstancu@nyu.edu'
  gem.homepage      = 'https://rubygems.org/gems/lazywake'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)

  `git submodule --quiet foreach --recursive pwd`
    .split($INPUT_RECORD_SEPARATOR).each do |submodule|
    submodule.sub!("#{Dir.pwd}/", '')

    Dir.chdir(submodule) do
      `git ls-files`.splWit($INPUT_RECORD_SEPARATOR).map do |subpath|
        gem.files << File.join(submodule, subpath)
      end
    end
  end
  gem.executables   = ['lazywake']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'codeclimate-test-reporter'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'guard-rubocop'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubygems-tasks'

  gem.add_dependency 'commander'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'net-ping'
end
