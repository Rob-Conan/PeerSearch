require 'socket'
require 'optparse'
require '../lib/MessageFormat.rb'
require '../lib/NetworkControl.rb'
require '../lib/Routing.rb'
require 'ap'

class PeerSearch
  attr_accessor :closest
  attr_accessor :node_ip
  attr_accessor :this_ip
  attr_accessor :mf
  attr_accessor :index
  attr_accessor :node_socket
  attr_accessor :routing
  attr_accessor :indexing


  #Initialize function to define the UDP socket connection

  def init(s1, ip)
    @mf = MessageFormat.new
    @node_socket = s1
    @this_ip = ip
    puts ip
    if ip !~ /\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]{1,6}\b/
      raise TypeError, 'Please use an IP address in the format of IP:PORT'
    end
  end

  def hashCode(input)
    hash = 0
    input.each_byte do |i|
      hash = (hash * 31) + i
    end
    return hash.abs
  end

  def joinNetwork(ip_address, index, closestID)
    @node_ip = ip_address.split(':')
    @index = hashCode(index.to_s)
    puts "This nodes ID: #{@index}"
    @closest = hashCode(closestID.to_s)
    puts "Closest ID: #{@closest}"
    @routing = Routing.new(@index, @this_ip)
    @indexing = Indexing.new
    @net = NetworkControl.new(@routing, @indexing)
    if @index != @closest #Not Bootstrap node
      @node_socket.bind(@this_ip.split(':')[0], @this_ip.split(':')[1])
      @node_socket.send @mf.JOINING_NETWORK_SIMPLIFIED(@index, @closest, @this_ip), 0, @node_ip[0], @node_ip[1]
    else
      @node_socket.bind(@node_ip[0], @node_ip[1])
    end
    $thread = Thread.new do
      @net.startListening(@node_socket)
    end
  end

  def leaveNetwork(network_id)
    @routing.routingTable.each do |b, c|
      @node_socket.send @mf.LEAVING_NETWORK(@index), 0, c.to_s.split(':')[0], c.to_s.split(':')[1]
    end
    pp 'Node disconneting'
    $thread.exit
  end

  def indexPage(url, words)
    #Waiting not efficient
    #With time, extend to use threads and dynamic variables
    $time1 = Time.now
    words.each do |a|
      puts "Sending #{a}"
      @routing.findClosest(hashCode(a))
      if !@routing.minIP.nil?
        pp "Sending to #{@routing.minIP}"
        if @index != @routing.minID #Don't send to ourselves
          @node_socket.send @mf.INDEX(hashCode(a), @index, a, url), 0, @routing.minIP[0], @routing.minIP[1]
          while Time.now - $time1 < 30 && !@net.ackIndex_receive
          end
          if !@net.ackIndex_receive
            puts 'No ACK received sending PING'
            if hashCode(a) != @index
              @node_socket.send @mf.PING(hashCode(a), @index, @this_ip), 0,  @routing.minIP[0], @routing.minIP[1]
              $time2 = Time.now
              while Time.now - $time2 < 10 && !@net.ack_receive
              end
              if !@net.ack_receive
                puts "Node #{@index} deleting #{@routing.minID} from Routing table"
                #@routing.deleteEntry(b)
              end
            end
          end
         # puts 'Succesful send'
        else
          #Add to our index
          @indexing.updateIndex(a,url)
        end
        @net.ack_receive = false
        @net.ackIndex_receive = false
      end
    end
    puts 'End of Index Function'
  end

  def search(words)
    words.each do |a|
      @routing.findClosest(hashCode(a))
      if !@routing.minIP.nil?
        @node_socket.send @mf.SEARCH(a, hashCode(a), @index), 0, @routing.minIP[0], @routing.minIP[1]
      end
    end

  end

end

class SearchResults
  attr_accessor :words
  attr_accessor :url
  attr_accessor :frequency

  def initialize(words, url, freq)
    @words = words
    @url = url
    @frequency = freq
  end

end