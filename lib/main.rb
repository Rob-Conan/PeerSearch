require '../lib/peer_search.rb'
require 'optparse'
require 'pp'

class Main

  n1 = PeerSearch.new
  s1 = UDPSocket.new

  n1.init(s1)
  n1.joinNetwork
  ##~~ More stuff goes here ~~##

end