# frozen_string_literal: true
module Lazywake
  module Network
    extend ActiveSupport::Autoload

    autoload :ARP
    autoload :MagicPacket
  end
end
