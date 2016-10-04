# frozen_string_literal: true
describe Lazywake::Command::DSL do
  context 'as a factory' do
    let(:command_name) { 'foobarium' }

    before do
      Lazywake::Command.describe do
        name 'foobarium'
        before { 'arbitrary musing' }
      end
    end

    let(:dynamic_class_name) do
      "#{described_class.name.deconstantize}::#{command_name.classify}"
    end

    let(:cli_args) { %w(never gonna give you args) }
    let(:instance) { dynamic_class_name.constantize.new(cli_args) }

    it 'creates the correct subclass' do
      expect { instance }.to_not raise_error
    end

    it 'has the correct attributes' do
      expect(instance.opts_struct.args).to eql(cli_args)
      expect(instance.send(:command_name)).to eql(command_name)
      expect(instance.send(:user_before)).to eql 'arbitrary musing'
    end
  end
end
