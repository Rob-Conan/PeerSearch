require 'socket'
require '../lib/MessageFormat.rb'

class NetworkControl
  attr_accessor :routingtable
  attr_accessor :index
  attr_accessor :midID
  attr_accessor :midIP
  attr_accessor :minvalue
  attr_accessor :routing_arry

  def initialize(id, ip)
    @routingtable = Hash.new
    @mf = MessageFormat.new
    @index = id
    @routing_array = []
    puts "My ID (Gateway): #{id}"
    #routingtable[id] = ip
  end

  def startListening(socket)
    loop do
    parse(socket.recv(100))
      end
  end


  def parse(response)
    process = JSON.parse(response)
    puts "Message contained: \n#{process}"
    case process['type']
      when 'JOINING_NETWORK'
        @minvalue = (process['node_id'].to_i - @index).abs
        updateRouting(process['node_id'], process['ip_address'])
        checkIDsize
        if @minID != @index && @minID != process['node_id']
          UDPSocket.open.send @mf.JOINING_NETWORK_REPLY(@minID, @index), 0, '127.0.0.1', @minIP
        end
      when 'JOINING_NETWORK_REPLY'
        @minvalue = (process['node_id'].to_i - @index).abs
        checkIDsize
        convertTable(routingtable)
        if @minID != @index && @minID != process['node_id']
          UDPSocket.open.send @mf.JOINING_NETWORK_REPLY(@minID, @index), 0, '127.0.0.1', @minIP
        end
        UDPSocket.open.send @mf.ROUTING_INFO(process['gateway_id'], @index, 8767, @routing_array), 0, '127.0.0.1', @minIP #NEED AN URL HERE
        puts "Routing table: #{@routing_array}"
      when 'ROUTING_INFO'
        #If routing info is null
        #Add the bootstrap node
        #else
        #Process and add to routing table
         convertTable(routingtable)
      when 'LEAVING_NETWORK'
        #Send message to all those in routing table
      when 'INDEX'

      when 'SEARCH'

      when 'SEARCH_RESPONSE'

      when 'PING'

      when 'ACK'

      else
        puts 'false'

    end
  end

  def checkIDsize
    routingtable.each do |id, ip|
      if @minvalue >= (id.to_i - @index).abs
        @minvalue = (id.to_i - @index).abs
        @minID = id
        @minIP = ip
      end
    end
  end

  def updateRouting(id, ip)
    if routingtable.empty?
      puts 'Table Empty'
    end
    if routingtable.has_key?(id)
      raise Exception, 'Index exists in Network. Index\'s (Node ID\'s) must be unique'
      #Should be a reply to the sending node
    else
      puts 'Adding to table'
      routingtable[id] = ip
      puts routingtable
    end
  end

  def convertTable(table)
    puts "Table: #{table}"
    i = 0
    table.each do |key, value|
      @routing_array.push({'node_id' => key, 'ip_address'=>value})
      puts "#{i} + #{@routing_array}"
      i=i+1
    end
  end
end