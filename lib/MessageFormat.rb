require 'json'
require 'json/add/core'

class MessageFormat

  def JOINING_NETWORK(id, ip)
    value = {:type => "JOINING_NETWORK", :node_id => id, :ip_address => ip}
    json = value.to_json
    return json
  end

  def JOINING_NETWORK_REPLY(id, gateway_id)
    value = {:type => "JOINING_NETWORK_REPLY", :node_id => id, :gateway_id => gateway_id}
    json = value.to_json
    return json
  end

   def ROUTING_INFO(gateway_id, node_id, ip_address)
     value = {:type => "ROUTING_INFO", :gateway_id => gateway_id, :node_id => node_id, :ip_address =>ip_address}
     json = value.to_json
     return json

     #How to return routing table?
   end

  def LEAVING_NETWORK(id)
    value = {:type => "LEAVING_NETWORK", :node_id => id}
    json = value.to_json
    return json
  end

end