require 'ap'

class Routing
  attr_accessor :minID
  attr_accessor :minIP
  attr_accessor :closestID
  attr_accessor :nodeID
  attr_accessor :nodeIP
  attr_accessor :nodeIPvalue

  def initialize(myID, myIP)
    @routingTable = Hash.new #Routing table as Hash
    @routingArray = [] #Routing table as Array
    @nodeID = myID
    @nodeIPvalue = myIP
    @nodeIP = myIP.to_s.split(':')
  end
  # Never used
  def convertToArray
    routingTable.each do |key, value|
      routingArray.push({'node_id' => key, 'ip_address' => value})
    end
  end
  # Update the routing table
  def update(id, ip)
    if routingTable.empty?
      puts 'Table empty'
    end
    if routingTable.has_key?(id)
      #raise Exception, 'Index exists in Network. Index\'s (Node ID\'s) must be unique'
    else
      puts "Adding #{id} and #{ip} to routing table"
      routingTable[id] = ip
    end
  end
  # Find closest node
  def findClosest(input)
    @closestID = (@nodeID * @nodeID).abs
    if @routingTable.has_key?(input)
      @minIP = @routingTable[input]
    end
    #Need condition if the orignal closestID is the closest
    routingTable.each do |id, ip|
      temp = (id.to_i - input).abs
      if @closestID >= temp
        @closestID = temp
        @minID = id
        @minIP = ip.to_s.split(':')
      end
    end
  end
# Broken logic
  def ifCloserNode(input)
    routingTable.each do |id, ip|
      if input.to_i < id.to_i
        puts "#{input.to_i} > #{id.to_i}"
        true
      end
    end
    false
  end

  def matchNodeID(id)
    if id == @nodeID
      true
    else
      false
    end
  end

  def deleteEntry(id)
    if routingTable.has_key?(id)
      puts "Deleting entry from table: #{id}"
      routingTable.delete(id)
    end
  end

  def routingTable
    @routingTable
  end

  def routingArray
    @routingArray
  end

end