# frozen_string_literal: true
module Lazywake
  module Network
    module ARP
      class << self
        def update_entries
          binding.pry
        end

        def entries
          {}.with_indifferent_access.tap do |entries_hash|
            `arp -a`.split("\n").each do |arp_entry|
              parts = tokenize_arp_entry(arp_entry)
              next if (host = parts.shift) == '?'

              entries_hash[host] = { ipv4: parts.shift.delete('(').delete(')'),
                                     hw: parts.shift.strip,
                                     interface: parts.shift.lstrip }
            end
          end
        end

        def tokenize_arp_entry(entry)
          (entry.split('at').tap do |arp_parts|
            arp_parts[-1] = arp_parts.last.split('on')
            arp_parts[0] = arp_parts.first.split(' ')
          end).flatten
        end
      end
    end
  end
end
