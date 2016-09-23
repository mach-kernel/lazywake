# frozen_string_literal: true
describe Lazywake::Network::MagicPacket do
  subject { described_class.instance }

  context '#initialize' do
    let(:bad_address) { double(:bad, ipv4_private?: false) }
    let(:good_address) { double(:good, ipv4_private?: true) }

    before do
      allow(Socket).to receive(:ip_address_list).and_return(
        [bad_address, good_address]
      )
    end

    it 'should only select ipv4 private addresses' do
      expect(subject.send(:local_addr_info)).to eql good_address
    end
  end

  context '#hw_address_bytes' do
    let(:mac) { '00:FF:22:33:44:55' }

    it 'should cast the mac addre$ss properly' do
      expect(subject.send(:hw_address_bytes, mac)).to eql(
        [0, 255, 34, 51, 68, 85]
      )
    end
  end

  context '#udp_socket' do
    it 'broadcast is not 0' do
      expect(
        subject.send(:udp_socket).getsockopt(
          Socket::SOL_SOCKET, Socket::SO_BROADCAST
        ).int
      ).to_not eql 0
    end
  end

  context '#local_broadcast_address' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:local_addr_info).and_return(
          double(
            :some_ip, ipv4_private: true,
                      ip_address: '123.222.111.043'
          )
        )
    end

    it 'should generate the correct broadcast address' do
      expect(subject.send(:local_broadcast_address)).to eql '123.222.111.255'
    end
  end

  context '#wake' do
    let(:mac) { '00:11:22:33:44:55' }

    before do
      allow(subject).to receive(:packet_body)
        .with(mac).and_return('hello world')
      allow(subject)
        .to receive(:local_broadcast_address).and_return('10.0.0.255')
    end

    it 'should call the correct dependencies' do
      expect(subject.send(:udp_socket)).to receive(:send).with(
        'hello world',
        0,
        '10.0.0.255',
        9
      )
      subject.wake(mac)
    end
  end

  context '#packet_body' do
    context 'the correct byte sequence' do
      let(:mac) { '00:11:22:33:44:55' }
      let(:body) { subject.send(:packet_body, mac) }

      it 'has 0xFF as the first 6 bytes' do
        expect(body.unpack('C*')[0..5]).to eql(Array.new(6, 0xFF))
      end

      it 'has the next 96 bytes of 16 repititions of the hardware address' do
        unpacked = body.unpack('C*')[6..-1]
        expect(unpacked.count).to eql(96)

        unpacked.each_slice(6) do |slice|
          expect(slice).to eql(mac.split(':').map { |x| x.to_i(16) })
        end
      end
    end
  end
end
