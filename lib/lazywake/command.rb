# frozen_string_literal: true
module Lazywake
  module Command
    extend ActiveSupport::Autoload
    extend Forwardable

    autoload :Default
    autoload :DSL

    def_delegator DSL, :describe, 'self.describe'
  end
end
