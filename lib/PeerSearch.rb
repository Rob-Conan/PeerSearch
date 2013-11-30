require 'PeerSearch/version'
require 'socket'

module PeerSearch

  class SearchResults


  end

  ARGV.each do|a|
    puts "Argument: #{a}"
  end

  #Initialize function to define the UDP socket connection
  def init(port)
    node = UDPSocket.new(port)
    node.bind(nil, 8767)
  end

  def joinNetwork(relay_node)

    return 1
  end

  def leaveNetwork(network_id)


      return true
  end

  def indexPage(url, *unique_words)


  end

  #Not sure how to define below
  #SearchResults[] search(*words)



end
