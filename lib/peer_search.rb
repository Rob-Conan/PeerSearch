require 'socket'
require '../lib/MessageFormat.rb'

class PeerSearch


  options = {}
  optparse = OptionParser.new do |opts|
    opts.banner = 'Usage: main.rb [options]'

    opts.on('--boot', '--b bootID', 'Bootstrap node ID') do |v|
      options[:gateway_id] = v
    end

    opts.on('--bootstrap', '--bs ID', 'Bootstrap node IP') do |a|
      options[:bootstrap_ip] = a
    end

    opts.on('--id ID', 'This nodes ID') do |b|
      options[:node_id] = b
    end

    opts.on('-p', '--port PORT', 'Port to connect to this node') do |p|
      options[:port] = p
    end
  end
  optparse.parse!


  RoutingTable = Hash.new
  @@gateway_id = 0
  @@node_id = 0
  #Initialize function to define the UDP socket connection

  def initialize(id)
    @@node_id = id
    @@node_id= hashCode(id)
  end

  def init(socket, started = nil)
    if started != nil
      puts "Boot Strap Node: #{started}"
      puts "Node ID: #{@@node_id}"
      puts 'Joining Node'
    else
      socket.recv(10)
      puts 'BootStrap Node'
    end
  end

  def hashCode(input)
    hash = 0
   input.each_byte do |i|
      hash = (hash * 31) + i
   end
    return hash.abs
  end

end
