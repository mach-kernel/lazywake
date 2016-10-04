# frozen_string_literal: true

module Lazywake
  module Command
    class Default
      DEFAULT_OPTS = {
        await_for: 0
      }.freeze

      def initialize(args)
        @opts = OpenStruct.new(DEFAULT_OPTS)
        @opts.args = args
      end

      def method_missing(sym, *args)
        if sym == :opts
          return opts_accessor(
            args.first, args.second
          ) if args.first.is_a?(Symbol) && DEFAULT_OPTS.key?(args.first)
        end
        super
      end

      def opts_struct
        @opts
      end

      def perform
        before_hooks
        replace_with_command
      end

      def respond_to_missing?(sym, include_private = false)
        sym == :opts ? true : super
      end

      private

      def before_hooks
        await_wake if respond_to?(:await_wake)
        user_before if respond_to?(:user_before)
      end

      def replace_with_command
        Kernel.exec(path, *@opts.args)
      end

      def path
        command = respond_to?(:command_name) ? command_name : @opts.args.shift
        `which #{command}`.rstrip
      end

      def opts_accessor(key, new_opts)
        return @opts.send(key) if new_opts.blank?
        @opts.send(:"#{key}=", new_opts)
      end
    end
  end
end
