# frozen_string_literal: true
describe Lazywake::Config do
  let(:config) do
    {
      lazywake_version: Lazywake::VERSION,
      mappings: {
        hostname: '00:00:00:00:00:00'
      }
    }.to_json
  end

  let(:path) { File.join(Dir.home, '.lazywake') }

  before { FileUtils.rm_rf(path) }

  context 'delegations' do
    it 'can load the file' do
      File.open(path, 'w+') { |f| f.write(config) }
      described_class.load(path)
      expect(described_class.lazywake_version).to eql Lazywake::VERSION
    end
  end
end
