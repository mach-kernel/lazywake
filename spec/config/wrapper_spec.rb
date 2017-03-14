# frozen_string_literal: true
require 'json'

describe Lazywake::Config::Wrapper do
  let(:valid_config_file) do
    {
      lazywake_version: Lazywake::VERSION,
      generated_mappings: {
        localtoast: '00:00:00:00:00:00'
      }
    }.to_json
  end

  let(:path) { File.join(Dir.home, '.lazywake') }

  before do
    described_class.reset
    expect(File).to receive(:exist?).with(path).and_return(true)
  end

  context '.load' do
    let(:invalid_config_file) { 'alphabet soup' }

    it 'parses a valid config file' do
      expect(File).to receive(:read).with(path).and_return(valid_config_file)
      described_class.load(path)
      expect(described_class.data).to be_a(Hash)
    end

    it 'fails with an invalid config' do
      expect(File).to receive(:read).with(path).and_return(invalid_config_file)

      expect { described_class.load(path) }
        .to raise_error(Lazywake::Config::Schema::ConfigValidationError)
      expect(described_class.data).to be(nil)
    end
  end

  context '.save' do
    before do
      expect(File).to receive(:read).with(path).and_return(valid_config_file)
      described_class.load(path)
    end

    it 'will save valid changes to the config' do
      Lazywake::Config.generated_mappings[:new_entry] = '12:34:56:78:90:11'

      expect_any_instance_of(File).to receive(:write)
        .with(Lazywake::Config.data.to_json)

      described_class.save(path)
    end

    it 'fails with an invalid field value' do
      Lazywake::Config
        .generated_mappings[:new_entry] = 'totally not a mac address'
      expect { described_class.save(path) }
        .to raise_error(Lazywake::Config::Schema::ConfigValidationError)
    end
  end
end
