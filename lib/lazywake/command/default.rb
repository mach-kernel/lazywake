# frozen_string_literal: true

module Lazywake
  module Command
    class Default
      def self.opts
        @opts ||= {
          await_for: 0,
          map_proc: nil
        }
      end

      def initialize(args)
        @args = args
      end

      def perform
        before_hooks
        replace_with_command
      end

      private

      attr_reader :args

      def await_wake
        while self.class.opts[:await_for].positive?
          return if remote_alive?
          sleep 1
          self.class.opts[:await_for] -= 1
        end
      end

      def before_hooks
        await_wake if self.class.opts[:await_for].positive?
        @args = args.tap(
          &self.class.opts[:map_proc]
        ) if self.class.opts[:map_proc].is_a?(Proc)
      end

      def remote_alive?
        # TODO: implement in sep. feature branch
        true
      end

      def replace_with_command
        Kernel.exec(path, *args)
      end

      def path
        command = respond_to?(:command_name) ? command_name : args.shift
        `which #{command}`.rstrip
      end
    end
  end
end
