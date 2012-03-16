module C45
  class Node
    EPSI = 0.00001

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
      node = self.parent
      while(!node.nil?) do
        result += 1
        node = node.parent
      end
      result
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
        if self.left.nil?
          left_str = "BUG"
        else
          left_str = self.left.to_s(true)
          unless self.left.is_a?(Result)
            left_str = "\n" + left_str
          end
        end
        if self.right.nil?
          right_str = "BUG"
        else
          right_str = self.right.to_s(true)
          unless self.right.is_a?(Result)
            right_str = "\n" + right_str
          end
        end
        "|   " * self.level + "#{@feature} <= #{@value} :" + left_str + "\n" +
          "|   " * self.level + "#{@feature} > #{@value} :" + right_str
      else
        "Node: #{@feature}: #{@value}"
      end
    end

    protected
    # Returns the node on the path that is compatible
    # with the +example+.
    def next_node(example)
      if example[@feature] <= @value || (example[@feature] - @value).abs < EPSI
        self.left
      else
        self.right
      end
    end
  end
end
