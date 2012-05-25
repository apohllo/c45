module C45
  class ContinuousNode < Node
    EPSI = 0.00001

    protected
    # Converts the node to pretty string representation.
    def pretty_to_s
      left_str = child_to_s(:left)
      right_str = child_to_s(:right)
      "|   " * self.level + "#{@feature} <= #{@value} :" + left_str + "\n" +
        "|   " * self.level + "#{@feature} > #{@value} :" + right_str
    end

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
