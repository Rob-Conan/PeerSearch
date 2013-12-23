require 'json'
require 'json/add/core'

class MessageFormat

  def initialize

  end

  def JOINING_NETWORK(id, ip)
    value = {:type => 'JOINING_NETWORK', :node_id => id, :ip_address => ip}
    return value.to_json

  end

  def JOINING_NETWORK_SIMPLIFIED(id, target, ip)
    value = {:type => 'JOINING_NETWORK_SIMPLIFIED', :node_id => id, :target_id => target, :ip_address => ip}
    return value.to_json

  end

  def JOINING_NETWORK_RELAY(id, gateway_id)
    value = {:type => 'JOINING_NETWORK_REPLY', :node_id => id, :gateway_id => gateway_id}
    return value.to_json

  end

  def JOINING_NETWORK_RELAY_SIMPLIFIED(id, target_id, gateway_id)
    value = {:type => 'JOINING_NETWORK_RELAY_SIMPLIFIED', :node_id => id, :target_id => target_id, :gateway_id => gateway_id}
    return value.to_json

  end

  def ROUTING_INFO(gateway_id, node_id, ip_address, route)
    value = {:type => 'ROUTING_INFO', :gateway_id => gateway_id, :node_id => node_id, :ip_address => ip_address, :route_table => route}
    return value.to_json

  end

  def LEAVING_NETWORK(id)
    value = {:type => 'LEAVING_NETWORK', :node_id => id}
    return value.to_json
  end

  def INDEX(target_id, sender_id, keyword, link)
    value = {:type => 'INDEX', :target_id => target_id, :sender_id => sender_id, :keyword => keyword , :link => link}
    return value.to_json
  end

  def SEARCH(word, node_id, sender_id)
    value = {:type => 'SEARCH', :word => word, :node_id => node_id, :sender_id => sender_id}
    return value.to_json
  end

  #How to handle multiple url and tanks?
  def SEARCH_RESPONSE(word, node_id, sender_id, response)
    value = {:type => 'SEARCH_RESPONSE', :word => word, :node_id => node_id, :sender_id => sender_id, :response => response}
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

  def ACK_INDEX(node_id, keyword)
    value = {:type => 'ACK_INDEX', :node_id => node_id, :keyword => keyword}
    return value.to_json
  end
end