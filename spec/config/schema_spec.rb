# frozen_string_literal: true
describe Lazywake::Config::Schema do
  context '.validate' do
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
      expect { subject.validate(valid_config) }.to_not raise_error
    end

    it 'fails an invalid config file' do
      expect { subject.validate(invalid_config) }
        .to raise_error(Lazywake::Config::Schema::ConfigValidationError)
    end
  end
end
