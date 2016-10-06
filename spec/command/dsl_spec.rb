# frozen_string_literal: true
describe Lazywake::Command::DSL do
  context 'as a factory' do
    before do
      Lazywake::Command.describe do
        name 'foobarium'
      end
    end

    let(:dynamic_class_name) do
      command_name = 'foobarium'
      "#{described_class.name.deconstantize}::#{command_name.classify}"
    end

    let(:cli_args) { %w(never gonna give you args) }
    let(:instance) { dynamic_class_name.constantize.new(cli_args) }

    context 'setup' do
      it 'creates the correct subclass' do
        expect { instance }.to_not raise_error
      end

      it 'has the correct attributes' do
        expect(instance.send(:command_name)).to eql('foobarium')
      end
    end
  end
end
