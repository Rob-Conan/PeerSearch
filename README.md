# PeerSearch

Originally designed as a gem, this is no longer the case. All files are contained inside the lib directory

## Usage

Main.rb is the "Test" file and is used to instanciate the project.

To set up the first node in the network on localhost:8767

 $ ruby main.rb --boot Command --bootstrap 127.0.0.1:8767

Subsequent nodes can then be defined using

 $ ruby main.rb --index Joining2 --bootid Command --port 127.0.0.1:8778 --bootstrap 127.0.0.1:8767

And for a node to request the indexing and searching of indexes on the network

 $ ruby main.rb --index Joining --bootid Command --port 127.0.0.1:8777 --bootstrap 127.0.0.1:8767 --send --search WORD

## Commands

The commands to run from the command line are as follows
 1. The ID of the Bootstrap node (when it is starting)

  --boot []

 2. The IP & Port combination for this individual node (Not needed if Bootstrap node)

  --port []

 3. The Bootstrap node IP

  --bootstrap []

 4. The Nodes Identifier/Index (Not needed if Bootstrap node)

  --index []

 5. The ID of the Bootstrap node (that this node will use to connect too)

  --bootid []

 6. A flag to say the Index message should be sent by this node

  --send

 7. The search term to search for on the network

  --search []
