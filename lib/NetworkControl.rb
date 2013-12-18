require 'socket'
require '../lib/MessageFormat.rb'
require '../lib/Routing.rb'
require '../lib/Indexing.rb'
require 'ap'

class NetworkControl


  def initialize(id, ip)
    @rt = Routing.new(id, ip)
    @mf = MessageFormat.new
    @in = Indexing.new
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
      when 'JOINING_NETWORK_SIMPLIFIED'
        #Is findClosestID using the correct input variable
        @rt.update(process['node_id'], process['ip_address'])
        @rt.findClosest(process['node_id'].to_i)
        if @rt.minID != @rt.nodeID && @rt.minID != process['node_id']
          #Not sure if target_id is correct
          UDPSocket.open.send @mf.JOINING_NETWORK_REPLY_SIMPLIFIED(
                                  process['node_id'], @rt.minID, process['target_id']),
                              0, process['ip_address'][0], process['ip_address'][1]
        end
      #If no other nodes
      when 'JOINING_NETWORK_REPLY_SIMPLIFIED'
        @rt.findClosest(process['node_id'].to_i)
        @rt.convertToArray
        if @rt.minID != @rt.nodeID && @rt.minID != process['node_id']
          UDPSocket.open.send @mf.JOINING_NETWORK_REPLY_SIMPLIFIED(
                                  process['node_id'], @rt.minID,
                                  process['target_id']), 0, @rt.minIP[0], @rt.minIP[1]
        end
      ###
      #UDPSocket.open.send @mf.ROUTING_INFO(process['gateway_id'],
      # @rt.nodeID, 8767, @rt.routingArray), 0, '127.0.0.1', @minIP #NEED AN URL HERE
      when 'ROUTING_INFO'
        if @rt.matchNodeID(process['node_id'])
          process['route_table'].each do |id, ip|
            #Add to routing table
            #Not sure if id and ip are correct as route_table is a hash of an array of hashes (hashception)
          end
        else
          #find closest
          #sent on
        end

      when 'LEAVING_NETWORK'
        @rt.deleteEntry(process['node_id'])

      when 'INDEX'
        if @rt.matchNodeID(process['target_id'])
          @in.updateIndex(process['keyword'], process['link'])
        else
          if @rt.ifCloserNode(process['target_id'])
            @rt.findClosest(process['target_id'])
            #INDEX message is not change so just forward
            UDPSocket.open.send process, 0, @rt.minIP[0], @rt.minIP[1]
          else
            #No closer Node - do Nothing
            pp "No closer node found than #{@rt.nodeID}"
          end
        end
        #Send back ACK
        @rt.findClosest(process['sender_id'])
        UDPSocket.open.send @mf.ACK(@rt.nodeID, @rt.nodeIP), 0, @rt.minIP[0], @rt.minIP[1]

      when 'SEARCH'
        if @rt.matchNodeID(process['node_id'])
          @rt.findClosest(process['sender_id'])
          UDPSocket.open.send @mf.SEARCH_RESPONSE(
                                  process['word'], process['sender_id'],
                                  @rt.nodeID, @in.getIndex(process['word'])),
                              0, @rt.minIP[0], @rt.minIP[1]
        else
          @rt.findClosest(process['node_id'])
          UDPSocket.open.send process, 0, @rt.minIP[0], @rt.minIP[1]
        end

      when 'SEARCH_RESPONSE'
        puts "The following results were found for your Query #{process['word']}"
        ap process['reponse']

      when 'PING'
        if @rt.matchNodeID(process['node_id'])
          @rt.findClosest(process['sender_id'])
          UDPSocket.open.send @mf.ACK(@rt.nodeID, @rt.nodeIP), 0, @rt.minIP[0], @rt.minIP[1]
        end

      when 'ACK'
        if @rt.matchNodeID(process[''])
        else
          puts 'false'
        end

    end
  end

end