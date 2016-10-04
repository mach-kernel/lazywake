# frozen_string_literal: true
module Lazywake
  module Command
    class DSL
      def self.describe(*_args, &block)
        new.instance_eval(&block)
      end

      private

      # TODO: At the expense of exceeding amounts of metaprogramming
      # this should be dynamically defined at runtime based on
      # what DEFAULT_OPTS are available since it is literally a wrapper
      def await_for(packets)
        @plugin.opts.await_for(packets)
      end

      def define_plugin
        return if @name.empty?
        Class.new(Command::Default).tap do |object|
          Lazywake::Command.const_set(@name.classify, object)
          object.send(
            :define_method,
            :command_name,
            -> { self.class.name.demodulize.underscore }
          )
          @plugin ||= object
        end
      end

      def name(str)
        @name = str if str.is_a?(String)
        define_plugin
      end

      def before(&block)
        @plugin.send(:define_method, :user_before, block)
      end
    end
  end
end
