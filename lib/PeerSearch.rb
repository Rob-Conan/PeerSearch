require 'PeerSearch/version'
require 'socket'

module PeerSearch

  ARGV.each do|a|
    puts "Argument: #{a}"
  end

  #Initialize function to define the UDP socket connection
  def init(port)
    node = UDPSocket.new(port)
    node.bind(nil, 8767)
  end

  def joinNetwork(relay_node)


  end

end
