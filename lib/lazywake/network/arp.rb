# frozen_string_literal: true
module Lazywake
  module Network
    module ARP
      # rubocop:disable Metrics/LineLength
      ARP_REGEX = /^(?<hostname>.*) (\((?<ipv4>(([1-9]?\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}([1-9]?\d|1\d\d|2[0-5][0-5]|2[0-4]\d))\)) at (?<hw>([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})).*on (?<interface>.*)/
      # rubocop:enable Metrics/LineLength

      class << self
        def update_entries
          Lazywake::Config.data['generated_mappings'].merge!(entries)
        end

        def entries
          {}.with_indifferent_access.tap do |entries_hash|
            `arp -a`.split("\n").each do |arp_entry|
              tokens = tokenize_arp_entry(arp_entry)
              entries_hash[tokens['hostname']] = tokens.except('hostname')
            end
          end
        end

        def tokenize_arp_entry(entry)
          entry.match(ARP_REGEX) { |m| return m.named_captures }
        end
      end
    end
  end
end
