module C45
  class Result
    attr_reader :klass, :positive, :negative

    # The +klass+ is the class selected by the rule.
    # The +positive+ is the number of positive examples and
    # the +negative+ - the number of negative examples.
    def initialize(klass,positive,negative)
      @klass = klass
      @positive = positive
      @negative = negative
    end

    def to_s(pretty=false)
      if pretty
        " #{@klass} (#{@positive}/#{@negative})"
      else
        "Result: #{@klass} #{@positive}/#{@negative}"
      end
    end

    # Converts the result into a hash.
    def to_hash
      {
        :class => self.klass,
        :positive => self.positive,
        :negative => self.negative,
        :prob => self.positive/(self.negative+self.positive)
      }
    end
  end
end
