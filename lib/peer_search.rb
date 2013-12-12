require 'socket'
require 'optparse'
require '../lib/MessageFormat.rb'
require '../lib/network_control.rb'

class PeerSearch
  attr_accessor :gateway_id
  attr_accessor :node_ip
  attr_accessor :gateway_ip
 # attr_accessor :is_bootstrap
  attr_accessor :options
 # attr_accessor :node_socket
  attr_accessor :mf
  attr_accessor :net
  attr_accessor :index

  @@options = {}

  optparse = OptionParser.new do |opts|
    opts.banner = 'Usage: main.rb [options]'

    opts.on('--boot', '--b bootID', 'Bootstrap ID') do |v|
      @@options[:node_id] = v
    end

    opts.on('-p', '--port PORT', 'Connection Port/IP') do |p|
      @@options[:port] = p
    end

    opts.on('--bootstrap', '--bs IP', 'Bootstrap node IP') do |a|
      @@options[:bootstrap_ip] = a
    end

    opts.on('--index', '--id IN', 'Node ID/Index') do |a|
      @@options[:index] = a
    end

  end
  optparse.parse!

  #Initialize function to define the UDP socket connection

  def init(s1)
    @mf = MessageFormat.new
    @node_socket = s1
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
  end

  def hashCode(input)
    hash = 0
    input.each_byte do |i|
      hash = (hash * 31) + i
    end
    return hash.abs
  end

  def joinNetwork
      if @is_bootstrap
        puts 'Waiting for Client'
        @net.startListening(@node_socket)
      else
        puts 'Sending...'
        @node_socket.send @mf.JOINING_NETWORK(@index.to_s, @node_ip), 0, '127.0.0.1', @gateway_ip
        @net.startListening(@node_socket)
      end
  end

  def options
    @@options
  end

end
