module C45
  class DiscreteNode < Node

    def level_step(node)
      if node == self.left
        1
      else
        0
      end
    end

    protected
    # Converts the node to pretty string representation.
    def pretty_to_s
      left_str = child_to_s(:left)
      right_str = child_to_s(:right)
      "|   " * self.level + "#{@feature} = #{@value}:" + left_str + right_str
    end

    # Returns the node on the path that is compatible
    # with the +example+.
    def next_node(example)
      if example[@feature].to_s == @value
        self.left
      else
        self.right
      end
    end
  end
end
