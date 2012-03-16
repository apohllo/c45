module C45
  class Forest
    attr_reader :trees

    def initialize
      @trees = []
    end

    # Adds the +tree+ to the forest.
    def <<(tree)
      @trees << tree
    end

    # Computes the probabilty that the example belongs
    # to the class it was classified as.
    def probability(example)
      weights_sum = [0.0,0.0]
      sum = [0.0,0.0]
      counts = [0,0]
      @trees.each do |tree|
        prob = tree.probability(example)
        weight = prob[:positive] + prob[:negative]
        next if weight == 0
        sum[prob[:class]] += weight * prob[:prob]
        weights_sum[prob[:class]] += weight
        counts[prob[:class]] += 1
      end
      #p [sum,weights_sum]
      probs = sum.zip(weights_sum).map{|s,w| s / w}
      #probs = sum.zip(counts).map{|s,w| s / w}
      if probs[0].nan?
        if probs[1].nan?
          {:class => 0, :prob => 0.51}
        else
          if probs[1] >= 0.5
            {:class => 1, :prob => probs[1]}
          else
            {:class => 0, :prob => 1-probs[1]}
          end
        end
      elsif probs[1].nan?
        if probs[0] >= 0.5
          {:class => 0, :prob => probs[0]}
        else
          {:class => 1, :prob => 1-probs[0]}
        end
      elsif probs[0] > probs[1]
        {:class => 0, :prob => probs[0]}
      else
        {:class => 1, :prob => probs[1]}
      end
    end

    # Classifies the +example+. It has to be in a form of a
    # :featrue => value map.
    def classify(example)
      self.probability(example)[:class]
    end

    # Saves the forest at the location given as +path+.
    def save(path)
      File.open(path,"w"){|out| out.puts Marshal.dump(self) }
    end

    # Loads the forest from the location given as +path+.
    def self.load(path)
      result = nil
      File.open(path){|input| result = Marshal.load(input)}
      result
    end
  end
end
