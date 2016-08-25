# frozen_string_literal: true
require 'lazywake'
require 'json'

describe Lazywake::Config::Schema do
  context '#valid?' do
    let(:valid_config) do
      {
        lazywake_version: Lazywake::VERSION,
        mappings: {
          hostname: '00:00:00:00:00:00'
        }
      }
    end

    let(:invalid_config) do
      {
        lazywake_version: ['a'],
        generated_mappings: {
          hostname: 'bill murray',
          hostname2: 'zz:zz:zz:zz:zz:zz'
        }
      }
    end

    it 'passes a valid config file' do
      expect(subject.valid?(valid_config)).to eql true
    end

    it 'fails an invalid config file' do
      expect { subject.valid?(invalid_config) }
        .to raise_error(Lazywake::Config::Schema::ConfigValidationError)
    end
  end
end
