# frozen_string_literal: true
describe Lazywake::Network::ARP do
  before do
    allow_any_instance_of(Kernel).to receive(:`).with('arp -a').and_return(
      "mario (10.0.0.1) at 00:11:22:33:44:55 on en4 ifscope [ethernet]\n"\
      'steve (10.0.0.144) at 22:34:55:01:39:A1 on en4 ifscope [ethernet]'
    )
  end

  context '.update_entries' do
    before { subject.update_entries }

    it 'should correctly update the configuration' do
      expect(Lazywake::Config.generated_mappings.keys)
        .to include('mario', 'steve')
    end
  end

  context '.entries' do
    it 'returns a hash with name -> info hash' do
      expect(subject.entries).to include(
        mario: {
          ipv4: '10.0.0.1',
          interface: 'en4 ifscope [ethernet]',
          hw: '00:11:22:33:44:55'
        }
      )
    end
  end
end
