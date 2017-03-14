# frozen_string_literal: true
module Lazywake
  module Command
    class DSL
      def self.describe(&block)
        new.instance_eval(&block)
      end

      private

      attr_reader :args

      # I think I found another Rubocop bug!
      # https://github.com/bbatsov/rubocop/issues/2707
      #
      # rubocop:disable Lint/NestedMethodDefinition
      def additional_methods
        @additional_methods ||= proc do
          def command_name
            self.class.name.demodulize.underscore
          end
        end
      end
      # rubocop:enable Lint/NestedMethodDefinition

      def class_path
        "Lazywake::Command::#{@name.classify}".constantize
      end

      def define_plugin
        return if @name.empty?

        @plugin ||= Class.new(Command::Default, &additional_methods).tap do |c|
          Lazywake::Command.const_set(@name.classify, c)
        end
      end

      def method_missing(sym, *args)
        return class_path.opts[sym] = args.first if class_path.opts.key?(sym)
        super
      end

      def name(str)
        @name = str if str.is_a?(String)
        define_plugin
      end

      def respond_to_missing?(sym, *args)
        Lazywake::Command::Default::OPTS.key?(sym) || super
      end
    end
  end
end
