class Routing
  attr_accessor :minID
  attr_accessor :minIP
  attr_accessor :closestID
  attr_accessor :nodeID
  attr_accessor :nodeIP

  def initialize(myID, myIP)
    @routingTable = Hash.new         #Routing table as Hash
    @routingArray = []               #Routing table as Array
    @nodeID = myID
    @nodeIP = myIP
  end

  def convertToArray
    routingTable.each do |key, value|
      routingArray.push({'node_id' => key, 'ip_address' => value})
    end
  end

  def update(id, ip)
    if routingTable.empty?
      puts 'Table empty'
    end
    if routingTable.has_key?(id)
      raise Exception, 'Index exists in Network. Index\'s (Node ID\'s) must be unique'
    else
      puts "Adding #{id} and #{ip} to routing table"
      routingTable[id] = ip
    end
  end

  def findClosest(input)
    @closestID = (input - @nodeID).abs
    #Need condition if the orignal closestID is the closest
    #Need value for minID and IP
    routingTable.each do |id, ip|
      temp = (id.to_i - @nodeID).abs
      if @closestID >= temp
        @closestID = temp
        @minID  = id
        @minIP  = ip
      end
    end
  end

  def ifCloserNode(input)
    routingTable.each do |id, ip|
      if input > id
        true
      end
      false
    end
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