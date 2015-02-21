require_relative 'b_event'

module EventSet
  class Any < BEvent
    def include?(e)
      true
    end

    def inspect
      "any"
    end

    @@instance = EventSet::Any.new
  end

  class None < BEvent
    def include?(e)
      false
    end

    def inspect
      "none"
    end

    @@instance = EventSet::None.new
  end

  def any
    return Any.instance
  end

  def none
    return None.instance
  end
end