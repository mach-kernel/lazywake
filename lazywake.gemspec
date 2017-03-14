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

  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.1'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'pry', '~> 0.10.4'
  gem.add_development_dependency 'rubocop', '0.42.0'
  gem.add_development_dependency 'guard', '2.14.0'
  gem.add_development_dependency 'guard-rubocop', '1.2.0'
  gem.add_development_dependency 'guard-rspec', '4.7.3'

  gem.add_dependency 'commander', '4.4.0'
  gem.add_dependency 'activesupport', '5.0.0.1'
  gem.add_dependency 'net-ping'
end
