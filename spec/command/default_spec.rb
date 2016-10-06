# frozen_string_literal: true
describe Lazywake::Command::Default do
  let(:args) { %w(look at some args ~) }

  subject { described_class.new(args) }

  context 'lifecycle methods' do
    before do
      lifecycle_commands.each do |cmd|
        expect_any_instance_of(described_class).to receive(cmd).and_return true
      end
    end

    context '#before_hooks' do
      let(:lifecycle_commands) { %i(await_wake) }

      before do
        subject.class.opts[:map_proc] = proc do |x|
          # no-op
        end

        subject.class.opts[:await_for] = 10
      end

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

  context '#perform' do
    context 'with a map_proc' do
      before do
        allow(subject).to receive(:replace_with_command).and_return true
        subject.class.opts[:map_proc] = proc { |x| x[0] = x[0].upcase }
        subject.perform
      end

      it 'upcases the first arg' do
        expect(subject.send(:args).first).to eql args.first.upcase
      end
    end
  end

  context '#replace_with_command' do
    before do
      allow(subject).to receive(:args).and_call_original
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
