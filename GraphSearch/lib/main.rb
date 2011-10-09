class Operation
  attr_reader :node,:search_type

  def initialize(node, search_type)
    @node=node
    @search_type=search_type
  end
end
class Graph
  attr_accessor :operations

  def initialize(vertex_array)
    require 'thread'
    @vertex_array=vertex_array
    @bfs_queue = Queue.new
    @operations=Array.new
  end

  def dfs(start_index)
    @first=true
    @vertex_array.each { |obj| obj.state=0 }
    run_dfs(@vertex_array[start_index])
    puts ""
  end

  def bfs(start_index)
    @first=true
    @vertex_array.each { |obj| obj.state=0 }
    @bfs_queue.clear
    run_bfs(@vertex_array[start_index])
    puts ""
  end

  private

  def run_dfs(start_node)
    current_vertex=start_node
    if not @first
      print " "
    end
    print current_vertex.value
    @first=false
    current_vertex.state = 1;
    adjacents=current_vertex.adjacents
    for i in 0..adjacents.size-1
      if adjacents[i].state == 0
        run_dfs(adjacents[i])
      end
    end
    current_vertex.state=2

  end

  def run_bfs(start_node)
    current_vertex=start_node
    current_vertex.state=1
    @bfs_queue.push(current_vertex)

    while not @bfs_queue.empty?
      v = @bfs_queue.pop()
      v.state=2
      if not @first
        print " "
      end
      print v.value
      @first=false
      adjacents=v.adjacents
      for i in 0..adjacents.size-1
        if adjacents[i].state == 0
          @bfs_queue.push(adjacents[i])
          adjacents[i].state=1
        end
      end
    end

 
  end
end

class InputReader
  @@graphCounter=0
  @@graphNodes=0

  def initialize()
    
  end

  def read_input()
    print "Zadejte pocet grafu:\n"
    @@graphCounter = Integer(gets)
    @@graphs=Array.new

    for i in 1..@@graphCounter
      
      print "Zadejte pocet uzlu grafu #{i}:\n"
      @@graphNodes=Integer(gets)
      created_nodes=Array.new(@@graphNodes)
      for j in 1..@@graphNodes
     
        print "Zadejte nasledovniky pro #{j}. uzel:\n"
        line = gets
        tokens = line.scan(/\w+/)

        index = Integer(tokens[0])-1
        if created_nodes[index]==nil

          current_node=Node.new(tokens[0])
          created_nodes[index] = current_node

        else

          current_node=created_nodes[index]
        
        end
        
        adjacents_counter = Integer(tokens[1])
        for k in 2..adjacents_counter + 1
         
          index1=Integer(tokens[k])-1
          if created_nodes[index1]==nil
            adjacent=Node.new(tokens[k])
            created_nodes[index1]=adjacent
          else
            adjacent=created_nodes[index1]
          end
         
          current_node.add_node(adjacent)
                    
        end
      end

      line=gets
      tokens = line.scan(/\w+/)
      start_node=Integer(tokens[0])
      search_type=Integer(tokens[1])

      graph=Graph.new(created_nodes)
      @@graphs.push(graph)

      while not (start_node==0 and search_type==0)

        
        if search_type==0
          graph.operations.push(Operation.new(start_node-1,0))
        else
          graph.operations.push(Operation.new(start_node-1,1))
        end

        line=gets
        tokens = line.scan(/\w+/)
        start_node=Integer(tokens[0])
        search_type=Integer(tokens[1])

        
      end
      
    end

    for i in 0..@@graphs.size-1
      puts "graph #{i+1}"
      graph=@@graphs[i]
      for j in 0..graph.operations.size-1
        operation=graph.operations[j]
        if operation.search_type==0
          graph.dfs(operation.node)
        else
          graph.bfs(operation.node)
        end
      end
    end
  end
    


  def graph_counter
    @@graphCounter
  end

  def graph_nodes
    @@graphNodes
  end

end

class Node
  attr_reader :value
  attr_accessor :state,:adjacents
  def initialize(value)
    @value = Integer(value)
    @state = 0
    @adjacents = Array.new
  end


  def add_node(node)
    @adjacents.push(node)
  end
end


reader=InputReader.new
reader.read_input()
