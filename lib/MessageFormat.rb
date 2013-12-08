require 'json'
require 'json/add/core'

class MessageFormat

  def initialize

  end

  def hello
    puts "Hello from Message Format"
  end

  def JOINING_NETWORK(id, ip)
    value = {:type => 'JOINING_NETWORK', :node_id => id, :ip_address => ip}
    return value.to_json

  end

  def JOINING_NETWORK_REPLY(id, gateway_id)
    value = {:type => 'JOINING_NETWORK_REPLY', :node_id => id, :gateway_id => gateway_id}
    return value.to_json

  end

  def ROUTING_INFO(gateway_id, node_id, ip_address)
    value = {:type => 'ROUTING_INFO', :gateway_id => gateway_id, :node_id => node_id, :ip_address => ip_address}
    return value.to_json


    #How to return routing table?
  end

  def LEAVING_NETWORK(id)
    value = {:type => 'LEAVING_NETWORK', :node_id => id}
    return value.to_json

    #Not complete
  end

  #Not sure on parameters
  def INDEX(target_id, sender_id, keyword, link)
    value = {:type => 'INDEX', :target_id => "VALUE", :sender_id => "VALUE", :keyword => "VALUE"} #, :link => { "VALUE", "VALUE"}}
    return value.to_json
  end

  def SEARCH(word, node_id, sender_id)
    value = {:type => 'SEARCH', :word => word, :node_id => node_id, :sender_id => sender_id}
    return value.to_json
  end

  #How to handle multiple url and tanks?
  def SEARCH_RESPONSE(word, node_id, sender_id, url, rank)
    value = {:type => 'SEARCH_RESPONSE', :word => word, :node_id => node_id, :sender_id => sender_id, :response => {:url => url, :rank => rank}}
    return value.to_json
  end

  def PING(target_id, sender_id, ip_address)
    value = {:type => 'PING', :target_id => target_id, :sender_id => sender_id, :ip_address => ip_address}
    return value.to_json
  end

  def ACK(node_id, ip_address)
    value = {:type => 'ACK', :node_id => node_id, :ip_address => ip_address}
    return value.to_json
  end
end