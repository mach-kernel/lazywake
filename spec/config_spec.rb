# frozen_string_literal: true
describe Lazywake::Config do
  let(:config) do
    {
      lazywake_version: Lazywake::VERSION,
      generated_mappings: {
        hostname: '00:00:00:00:00:00'
      }
    }.to_json
  end

  let(:path) { File.join(Dir.home, '.lazywake') }

  before { FileUtils.rm_rf(path) }

  context 'retrieving attributes' do
    it 'can access schema objects by key' do
      File.open(path, 'w+') { |f| f.write(config) }
      described_class.load(path)
      expect(described_class.lazywake_version).to eql Lazywake::VERSION
    end
  end

  context 'setting attributes' do
    it 'changes schema objects by key' do
      File.open(path, 'w+') { |f| f.write(config) }
      described_class.load(path)

      described_class.generated_mappings[:localtoast] = '11:11:11:11:11:11'
      described_class.save(path)

      expect(JSON.parse(File.read(path)).fetch('generated_mappings'))
        .to eql described_class.generated_mappings
    end
  end
end
