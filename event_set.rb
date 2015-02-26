require_relative 'b_event'

module EventSet
  class Any < BEvent
    def include?(e)
      true
    end

    def inspect
      "any"
    end

    @@instance = Any.new

    def self.instance
      return @@instance
    end
  end

  class None < BEvent
    def include?(e)
      false
    end

    def inspect
      "none"
    end

    @@instance = None.new

    def self.instance
      return @@instance
    end
  end

  def EventSet.any
    return Any.instance
  end

  def EventSet.none
    return None.instance
  end

  class EventsOfClass < BEvent

    def initialize(klass)
      @klass = klass
    end

    def include?(e)
      e.is_a? @klass
    end

    def inspect
      "events_of_class_#{@klass}"
    end

  end

  def EventSet.event_of_class(klass)
    return EventsOfClass.new klass
  end
end