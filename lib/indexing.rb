require 'pp'
require 'json'
require 'json/add/core'
require 'ap'


class Indexing

  def initialize
    @indexTable = Hash.new
  end

  def addIndex(url, keyword, rank)
    if @indexTable[keyword].nil?
      @indexTable[keyword] = [{:url => url, :rank => rank}]
    else
      @indexTable[keyword].push({:url => url, :rank => rank})
    end
  end

  def updateIndex(keyword, url)
    if @indexTable[keyword].nil?
      addIndex(url, keyword, 1)
    else
      counter = 0
      @indexTable[keyword].each do |a|
        if a[:url] == url
          temp = a[:rank].to_i + 1
          @indexTable[keyword].delete_at(counter)
          @indexTable[keyword].push({:url => url, :rank => temp.to_s})
        end
        counter = counter + 1
      end
    end
  end

  def printTable
    ap @indexTable, :index => false
  end

  def getIndex(keyword)
    @indexTable[keyword]
  end

end