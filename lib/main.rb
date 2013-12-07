require '../lib/peer_search.rb'
require 'optparse'
require 'pp'

class Main

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

  ##~~ Create Sockets ~~##
    s1 = UDPSocket.new
    s1.bind('127.0.0.1', options[:port])

  ##~~ Create node instances ~~##

  if options[:gateway_id] == nil
    node1 = PeerSearch.new(options[:node_id])
    node1.init(s1,  options[:bootstrap_ip])
  else
    node1 = PeerSearch.new(options[:gateway_id])
    node1.init(s1)
  end


  ##~~ More stuff goes here ~~##


end