require 'socket'
require '../lib/MessageFormat.rb'

class NetworkControl
  attr_accessor :routingtable

  def initialize(id, ip)
    @routingtable = Hash.new
    @mf = MessageFormat.new
    routingtable[id] = ip
  end

  def startListening(socket)
    loop do
      parse(socket.recv(100))
    end
  end


  def parse(response)
    process = JSON.parse(response)
    puts process
    case process['type']
      when 'JOINING_NETWORK'
        updateRouting(process['node_id'], process['ip_address'])
        #Works but needs to be the correct message
        UDPSocket.open.send @mf.JOINING_NETWORK(1, 2), 0, '127.0.0.1', process['ip_address']
        #SEND RESPONSE
      when 'JOINING_NETWORK_REPLY'

      when 'ROUTING_INFO'

      when 'LEAVING_NETWORK'

      when 'INDEX'

      when 'SEARCH'

      when 'SEARCH_RESPONSE'

      when 'PING'

      when 'ACK'

      else
        puts 'false'

    end
  end

  def updateRouting(id, ip)
    if routingtable.empty?
      routingtable[id] = ip
      puts routingtable
    elsif routingtable.has_key?(id)
      raise Exception, 'Index exists in Network. Index\'s (Node ID\'s) must be unique'
    else
      routingtable[id] = ip
      puts routingtable
    end
  end

end