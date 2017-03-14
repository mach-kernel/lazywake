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

  before do
    expect(File).to receive(:exist?).with(path).and_return(true)
    expect(File).to receive(:read).with(path).and_return(config)
  end

  context 'retrieving attributes' do
    it 'can access schema objects by key' do
      described_class.load(path)
      expect(described_class.lazywake_version).to eql Lazywake::VERSION
    end
  end

  context 'setting attributes' do
    it 'changes schema objects by key' do
      described_class.load(path)
      described_class.generated_mappings[:localtoast] = '11:11:11:11:11:11'
      expect(described_class.generated_mappings[:localtoast]).to eql(
        '11:11:11:11:11:11'
      )

      expect_any_instance_of(File)
        .to receive(:write).with(described_class.data.to_json)

      described_class.save(path)
    end
  end
end
