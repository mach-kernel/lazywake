# frozen_string_literal: true
require 'json'

describe Lazywake::Config::Wrapper do
  context 'validation' do
    let(:valid_config_file) do
      {
        lazywake_version: Lazywake::VERSION,
        generated_mappings: {
          localtoast: '00:00:00:00:00:00'
        }
      }.to_json
    end

    let(:invalid_config_file) { 'alphabet soup' }

    let(:path) { File.join(Dir.home, '.lazywake') }

    before do
      FileUtils.rm_rf(path)
      described_class.reset
    end

    it 'parses a valid config file' do
      File.open(path, 'w+') { |f| f.write(valid_config_file) }
      described_class.load(path)
      expect(described_class.data).to be_a(Hash)
    end

    it 'fails with an invalid config' do
      File.open(path, 'w+') { |f| f.write(invalid_config_file) }
      expect { described_class.load(path) }
        .to raise_error(Lazywake::Config::Schema::ConfigValidationError)
      expect(described_class.data).to be(nil)
    end
  end
end
