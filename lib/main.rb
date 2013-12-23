require '../lib/PeerSearch.rb'
require '../lib/Indexing.rb'
require 'optparse'
require 'pp'
require 'ap'

class Main
  attr_accessor :options

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

    opts.on('--bootid', '--bootid ID', 'Bootstrap ID') do |i|
      @@options[:closest] = i
    end

    opts.on('--send', 'Send Index Message') do |send|
      @@options[:send] = send
    end

    opts.on('--search', '--search [search]', 'Search for keyword') do |search|
      @@options[:search] = search
    end

  end
  optparse.parse!

  n1 = PeerSearch.new
  s1 = UDPSocket.new
  ind = Indexing.new

=begin
  ind.addIndex('http://test.com', 'Hello', '4')
  ind.addIndex('test2.com', 'Bye', '5')
  ind.updateIndex('Hello', 'http://test.com')
  ap ind.getIndex('Bye')
  #ind.printTable
=end


  if !@@options[:node_id].nil?
    if @@options[:bootstrap_ip].nil?
      raise TypeError, 'Please include the Bootstrap node IP'
    end
    puts 'BootStrap node'
    n1.init(s1, @@options[:bootstrap_ip])
    n1.joinNetwork(@@options[:bootstrap_ip], @@options[:node_id], @@options[:node_id])
  else
    if @@options[:bootstrap_ip].nil?
      raise TypeError, 'Please include the Bootstrap node IP'
    end
    if @@options[:port].nil?
      raise TypeError, 'Please include this Node\'s IP Address'
    end
    if @@options[:index].nil?
      raise TypeError, 'Please include this Node\'s ID\Index value'
    end
    if @@options[:closest].nil?
      raise TypeError, 'Please include the nearest node ID to this node'
    end
    puts 'Client node'
    n1.init(s1, @@options[:port])
    n1.joinNetwork(@@options[:bootstrap_ip], @@options[:index], @@options[:closest])
    if !@@options[:send].nil?
      stuff = []
      sleep(10)
      stuff.push('Joining2')
      stuff.push('Joinin')
      n1.indexPage('http://test.com', stuff)
      sleep(10)
    end
    if !@@options[:search].nil?
      search = []
      search.push('Joining2')
      n1.search(search)
    end
    #n1.leaveNetwork(1)
  end

  $thread.join
end