require 'socket'
require 'optparse'
require '../lib/MessageFormat.rb'
require '../lib/NetworkControl.rb'

class PeerSearch
  attr_accessor :gateway_id
  attr_accessor :node_ip
  attr_accessor :this_ip
  attr_accessor :mf
  attr_accessor :index
  attr_accessor :node_socket



  #Initialize function to define the UDP socket connection

  def init(s1, ip)
    @mf = MessageFormat.new
    @node_socket = s1
    @this_ip = ip.to_s.split(':')
=begin
    if options[:node_id] != nil                    #If the bootstrap node
      puts 'Bootstrap Node'
      @is_bootstrap = true
      @gateway_id = hashCode(options[:node_id])
      @node_socket.bind('127.0.0.1', 8767)
      @index = @gateway_id
      puts "Node ID: #{@index}"
    else
      if options[:bootstrap_ip] == nil
        raise TypeError, 'Please include the Bootstrap node Port'
      end
      if options[:port] == nil
        raise TypeError, 'Please include this Node\'s IP Address'
      end
      if options[:index] == nil
        raise TypeError, 'Please include this Node\'s ID\Index value'
      end
      puts 'Joining Node'
      @is_bootstrap = false
      @gateway_ip = options[:bootstrap_ip]
      @node_ip = options[:port]
      @node_socket.bind('127.0.0.1', @node_ip)
      @index = hashCode options[:index]

      puts "Boot strap IP: #{@gateway_ip}"
      puts "Node IP: #{@node_ip}"
      puts "Node ID: #{@index}"

    end

    @net = NetworkControl.new(@index, @node_ip)
=end
  end

  def hashCode(input)
    hash = 0
    input.each_byte do |i|
      hash = (hash * 31) + i
    end
    return hash.abs
  end

  def joinNetwork(ip_address, index, bootID)
    @node_ip = ip_address.split(':')
    @index = hashCode(index.to_s)
    @gateway_id = hashCode(bootID.to_s)

    @net = NetworkControl.new(@index, @node_ip)

    if @index != @gateway_id      #Not Bootstrap node
      puts 'Client Node'
      @node_socket.bind(@this_ip[0], @this_ip[1])
      @node_socket.send @mf.JOINING_NETWORK_SIMPLIFIED(@index, @gateway_id, @this_ip), 0, @node_ip[0], @node_ip[1]
    else
      @node_socket.bind(@node_ip[0], @node_ip[1])
    end
    $thread = Thread.new do
      @net.startListening(@node_socket)
    end
  end


end
