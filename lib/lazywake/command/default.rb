# frozen_string_literal: true
require 'net/ping'

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
        return unless self.class.opts[:map_proc].is_a?(Proc)
        @args = args.tap(&self.class.opts[:map_proc])
      end

      def host
        @host ||= begin
          h = Config.generated_mappings.merge(Config.user_mappings)
            .fetch(args.first, nil)
          raise 'Host not found' unless h.present?
          h
        end
      end

      def path
        command = respond_to?(:command_name) ? command_name : args.shift
        `which #{command}`.rstrip
      end

      def remote_alive?
        Net::Ping::External.new(args.first).tap { |n| return n.ping? }
      end

      def replace_with_command
        Kernel.exec(path, *args)
      end
    end
  end
end
