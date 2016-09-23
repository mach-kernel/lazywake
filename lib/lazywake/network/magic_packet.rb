# frozen_string_literal: true
require 'socket'

module Lazywake
  module Network
    class MagicPacket
      def self.instance
        @instance ||= new
      end

      def initialize
        @local_addr_info =
          Socket.ip_address_list.select(&:ipv4_private?).first
      end

      def wake(hw_address)
        # Use TCP/UDP discard port
        udp_socket.send(
          packet_body(hw_address),
          0,
          local_broadcast_address,
          9
        )
      end

      private

      attr_reader :local_addr_info

      def hw_address_bytes(hw_address)
        hw_address.split(':').map { |x| x.to_i(16) }
      end

      def local_broadcast_address
        local_addr_info
          .ip_address
          .split('.')
          .tap { |p| p[-1] = '255' }.join('.')
      end

      def packet_body(hw_address)
        sync_stream = Array.new(6, 0xFF)
        destination_loop =
          [].tap { |a| 16.times { |_x| a << hw_address_bytes(hw_address) } }

        sync_stream.concat(destination_loop.flatten).pack('C*')
      end

      def udp_socket
        @udp_socket ||= UDPSocket.new.tap do |socket|
          socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
        end
      end
    end
  end
end
