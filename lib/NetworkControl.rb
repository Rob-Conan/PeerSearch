require 'socket'
require '../lib/MessageFormat.rb'
require '../lib/Routing.rb'
require '../lib/Indexing.rb'
require 'ap'

class NetworkControl
  attr_accessor :ackIndex_receive
  attr_accessor :ack_receive

  def initialize(routeInfo, indexing)
    @rt = routeInfo
    @mf = MessageFormat.new
    @in = indexing
    @ackIndex_receive = false
    @ack_receive = false
  end

  def startListening(socket)
    loop do
      parse(socket.recv(1000))
    end
  end

  def parse(response)
    process = JSON.parse(response)
    puts "Node #{@rt.nodeID} received the following:"
    ap process
    case process['type']
      when 'JOINING_NETWORK_SIMPLIFIED'
        @rt.update(process['node_id'], process['ip_address'])
        @rt.findClosest(process['node_id'].to_i)
        if @rt.minID != @rt.nodeID && @rt.minID != process['node_id']
          #Not sure if target_id is correct
          UDPSocket.open.send @mf.JOINING_NETWORK_RELAY_SIMPLIFIED(
                                  process['node_id'], process['target_id'], @rt.nodeID),
                              0, @rt.minIP[0], @rt.minIP[1]
        else
          puts 'No other nodes to contact'
          nodeIP = process['ip_address']
          #puts "Node id #{@rt.nodeID}"
          tempTable = @rt.routingTable
          tempTable[@rt.nodeID] = @rt.nodeIPvalue
          UDPSocket.open.send @mf.ROUTING_INFO(@rt.nodeID, process['node_id'], @rt.nodeIPvalue, tempTable), 0, nodeIP.split(':')[0], nodeIP.split(':')[1]
        end
      when 'JOINING_NETWORK_RELAY_SIMPLIFIED'
        if @rt.findClosest(process['node_id'].to_i) != @rt.nodeID
          if @rt.minID != @rt.nodeID && @rt.minID != process['node_id']
            UDPSocket.open.send @mf.JOINING_NETWORK_RELAY_SIMPLIFIED(
                                    process['node_id'], process['target_id'],
                                    process['gateway_id']), 0, @rt.minIP[0], @rt.minIP[1]
          end
        end
        @rt.findClosest(process['gateway_id'])
        UDPSocket.open.send @mf.ROUTING_INFO(process['gateway_id'], process['node_id'],
                                             @rt.nodeIP, @rt.routingArray), 0, @rt.minIP[0], @rt.minIP[1]
      when 'ROUTING_INFO'
        if @rt.matchNodeID(process['node_id'])
          process['route_table'].each do |id, ip|
            if id.to_i != @rt.nodeID.to_i
              @rt.update(id, ip)
            end
            #Not sure if id and ip are correct as route_table is a hash of an array of hashes (hashception)
          end
        else
          @rt.findClosest(process['gateway_id'])
          UDPSocket.open.send @mf.ROUTING_INFO(process['gateway_id'], process['node_id'],
                                               @rt.nodeIP, @rt.routingArray), 0, @rt.minIP[0], @rt.minIP[1]

        end
      when 'LEAVING_NETWORK'
        puts "Deleting Entry #{process['node_id']}"
        @rt.deleteEntry(process['node_id'])
      when 'INDEX'
        if @rt.matchNodeID(process['target_id'])
          @in.updateIndex(process['keyword'], process['link'])
          @rt.findClosest(process['sender_id'])
          puts "Sending back ACK_INDEX from #{@rt.nodeID}"
          puts "Sender #{process['sender_id']}"
          puts "Node IP: #{@rt.minIP}"
          UDPSocket.open.send @mf.ACK_INDEX(process['sender_id'], process['keyword']), 0, @rt.minIP[0], @rt.minIP[1]
        else
          if @rt.findClosest(process['target_id'].to_i) != @rt.nodeID
            UDPSocket.open.send @mf.INDEX(process['target_id'], process['sender_id'], process['keyword'], process['link']), 0, @rt.minIP[0], @rt.minIP[1]
          else
            #No closer Node - do Nothing
            pp "No closer node found from #{@rt.nodeID}"
          end
        end
      when 'SEARCH'
        if @rt.matchNodeID(process['node_id'])
          @rt.findClosest(process['sender_id'])
          puts "#{process['word']}"
          @in.printTable
          UDPSocket.open.send @mf.SEARCH_RESPONSE(
                                  process['word'], process['sender_id'],
                                  @rt.nodeID, @in.getIndex(process['word'])),
                              0, @rt.minIP[0], @rt.minIP[1]
          puts 'Found correct node'
        else
          @rt.findClosest(process['node_id'])
          UDPSocket.open.send @mf.SEARCH(process['word'], process['node_id'], process['sender_id']), 0, @rt.minIP[0], @rt.minIP[1]
        end
      when 'SEARCH_RESPONSE'
        if @rt.matchNodeID(process['node_id'])
          puts "The following results were found for your Query #{process['word']}"
          ap process['response']
          process['response']
        else
          @rt.findClosest(process['node_id'])
          UDPSocket.open.send @mf.SEARCH_RESPONSE(process['word'], process['node_id'],
                                                  process['sender_id'], process['response']),
                              0, @rt.minIP[0], @rt.minIP[1]
        end
      when 'PING'
        if @rt.matchNodeID(process['node_id'])
          UDPSocket.open.send @mf.ACK(@rt.nodeID, @rt.nodeIP), 0, process['ip_address'].to_s.split(':')[0], process['ip_address'].to_s.split(':')[1]
        end
      when 'ACK'
        if @rt.matchNodeID(process['node_id'])
          @ack_receive = true
        else
          @rt.findClosest(process['node_id'])
          UDPSocket.open.send @mf.ACK(@rt.nodeID, @rt.nodeIP), 0, @rt.minIP[0], @rt.minIP[1]
        end
      when 'ACK_INDEX'
        if @rt.matchNodeID(process['node_id'])
          puts "ACK_INDEX received from #{process['keyword']}"
          @ackIndex_receive = true
        else
          @rt.findClosest(process['node_id'])
          puts "Forwarding INDEX to #{@rt.minIP}"
          UDPSocket.open.send @mf.ACK_INDEX(process['node_id'], process['keyword']), 0, @rt.minIP[0], @rt.minIP[1]
        end
      else
        puts 'No match'
    end
  end

  def ackIndex_receive
    @ackIndex_receive
  end

  def ack_receive
    @ack_receive
  end

end