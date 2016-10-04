# frozen_string_literal: true
describe Lazywake::Command::Default do
  let(:args) { %w(ls ~) }

  subject { described_class.new(args) }

  let(:default_opts) do
    { await_for: 12 }
  end

  before { stub_const("#{described_class}::DEFAULT_OPTS", default_opts) }

  context '#opts' do
    it 'sets things' do
      subject.opts(:await_for, 25)
      expect(subject.opts(:await_for)).to eql 25
    end

    it 'gets things' do
      k, v = default_opts.first
      expect(subject.send(:opts, k)).to eql v
    end
  end

  context 'lifecycle methods' do
    before do
      lifecycle_commands.each do |cmd|
        expect_any_instance_of(described_class).to receive(cmd).and_return true
      end
    end

    context '#before_hooks' do
      let(:lifecycle_commands) { %i(await_wake user_before) }

      it 'has the correct lifecycle' do
        subject.send(:before_hooks)
      end
    end

    context '#perform' do
      let(:lifecycle_commands) { %i(before_hooks replace_with_command) }

      it 'has the correct lifecycle' do
        subject.perform
      end
    end
  end

  context '#replace_with_command' do
    before do
      allow(subject.opts_struct).to receive(:args).and_call_original
      expect(Kernel).to receive(:exec) do |*args|
        expect(args.first).to eql `which #{args.first}`.rstrip
        expect(args.second).to be_a String
      end
    end

    it 'should retrieve and call the correct methods' do
      subject.send(:replace_with_command)
    end
  end
end
