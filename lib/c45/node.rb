module C45
  class Node
    attr_reader :feature, :value

    # The parent node of this node.
    attr_accessor :parent

    # The left node is the one with value below or equal (<=) to the split value
    # (for continuous values) or with the value present (for discrete values).
    attr_accessor :left

    # The right node is the one with value over (>) the split value
    # (for continuous values) or with the value absent (for discrete values).
    attr_accessor :right

    # The node with the split +value+ for the +feature+.
    def initialize(feature,value,parent=nil)
      @feature = feature.to_sym
      @value = value
      @parent = parent
    end

    # Returns the level of the node, that is its distance
    # from the tree root.
    def level
      result = 0
      node = self
      while(!node.nil?) do
        result += node.parent.level_step(node) if node.parent
        node = node.parent
      end
      result
    end

    def level_step(node)
      1
    end


    # Saves the (sub)tree at the location given as +path+.
    def save(path)
      File.open(path,"w"){|out| out.puts Marshal.dump(self) }
    end

    # Loads the tree from the location given as +path+.
    def self.load(path)
      result = nil
      File.open(path){|input| result = Marshal.load(input)}
      result
    end

    # Classifies the +example+. It has to be in a form of a
    # :featrue => value map.
    def classify(example)
      self.probability[:klass]
    end

    # Computes the probabilty that the example belongs
    # to the class it was classified as. The result is a hash:
    # * :class - the computed class
    # * :prob - the probability
    # * :positive - the number of positive examples
    # * :negative - the number of negative examples
    def probability(example)
      if Node === self.next_node(example)
        self.next_node(example).probability(example)
      else
        self.next_node(example).to_hash
      end
    end

    # Converts the node to string representation.
    # If +pretty+ is true, full (sub)tree is printed.
    def to_s(pretty=false)
      if pretty
        pretty_to_s
      else
        "#{self.class.to_s.split("::").last}: #{@feature}: #{@value}"
      end
    end

    protected
    # Returns pretty representation of the child at +side+.
    def child_to_s(side)
      unless side == :left || side == :right
        raise ArgumentError.new("Invalid node side #{side}.")
      end
      if self.__send__(side).nil?
        result = ""
      else
        result = self.__send__(side).to_s(true)
        unless self.__send__(side).is_a?(Result)
          result = "\n" + result
        end
      end
      result
    end
  end
end
