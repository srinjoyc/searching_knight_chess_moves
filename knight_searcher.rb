require './square.rb'
require 'byebug'

class KnightSearcher

    def initialize 
      @stack = []
      @queue = []
      @moves = []
    end 

  def inbounds?(x,y)
    return true if x.between?(0,8) && y.between?(0,8)
  end

  def getChildren(x,y,root)
    children = []
    r1 = Square.new(x+1,y+2, [], root) if inbounds?(x+1,y+2)
    r2 = Square.new(x+2,y+1, [], root) if inbounds?(x+2,y+1)        
    r3 = Square.new(x+1,y-2, [], root) if inbounds?(x+1,y-2)
    r4 = Square.new(x+2,y-1, [], root) if inbounds?(x+2,y-1)
    l1 = Square.new(x-1,y+2, [], root) if inbounds?(x-1,y+2) 
    l2 = Square.new(x-2,y+1, [], root) if inbounds?(x-2,y+1) 
    l3 = Square.new(x-2,y-1, [], root) if inbounds?(x-2,y-1) 
    l4 = Square.new(x-1,y-2, [], root) if inbounds?(x-1,y-2)
    if(r1 != nil)
      children.push(r1)
    end
    if(r2 != nil)
      children.push(r2)
    end
    if(r3 != nil)
      children.push(r3)
    end
    if(r4 != nil)
      children.push(r4)
    end
    if(l1 != nil)
      children.push(l1)
    end
    if(l2 != nil)
      children.push(l2)
    end 
    if(l3 != nil)
      children.push(l3)
    end
    if(l4 != nil)
      children.push(l4)
    end
    return children
  end

  def check_children(moves,target, type)
    moves.each do |move| #all moves from present location
      if move.x == target.x && move.y == target.y
        return move
      else
        if(move != nil) 
          @queue.push(move) if type == "bfs"
          @stack.push(move) if type == "dfs"
        end 
      end 
    end
    return false 
  end

  def get_move_tree(found_node)
    if(found_node.parent == nil)
      @moves.push(found_node)
      return @moves
    end 
      @moves.push(found_node)
      found_node = get_move_tree(found_node.parent)
  end 

  def search_bf(root,target,queue=nil)
    if(queue == nil)
      @counter = 0
      root.children = getChildren(root.x,root.y,root)
      result = check_children(root.children,target, "bfs")
      if result
        #puts "Found #{result.x}, #{result.y}"
        return true
      end
    end
    if(@queue.empty?)
      return false
    end 
    root = @queue.shift
    #puts "Checking root: #{root.x}, #{root.y}"
    root.children = getChildren(root.x,root.y,root)
    result = check_children(root.children, target, "bfs")
    if result
      #puts "Found #{result.x}, #{result.y} in #{@counter} steps "
      move_tree = get_move_tree(result)
      return move_tree
    end
    @counter += 1
    search_bf(root,target,@queue)
  end

  def get_depth_children(root)
    #implementing

  end 

  def search_df(root,target,stack=nil)
    if(stack == nil)
      @counter = 0
      root.children = getChildren(root.x,root.y,root)
      result = check_children(root.children, target, "dfs")
    end
    root = @stack.pop



  end 

end

start = Square.new(4,4,nil,nil)
target = Square.new(0,0,nil,nil)
searcher = KnightSearcher.new()

start_time = Time.now
moves = searcher.search_bf(start,target)
end_time = Time.now
search_time = (end_time - start_time)*1000
puts "BFS took: #{search_time} ms"
puts "To get to #{target.x}, #{target.y} move to the following squares"
moves.reverse.each_with_index do |move, index|
  puts "Step #{index}: #{move.x} #{move.y}" if index != 0 
end 

