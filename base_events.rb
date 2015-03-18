require_relative 'b_event'
require 'singleton'

module BaseEvents

  class EventSetClass < BEvent

    attr_reader :events

    def initialize(name, *events)
      @name = name
      @events = events
    end

    def include?(e)
      @events.include? e
    end

    def inspect
      @name
    end

  end

  class Any < BEvent
    include Singleton

    def initialize
      super 'any'
    end

    def include?(e)
      true
    end

  end

  class None < BEvent
    include Singleton

    def initialize
      super "none"
    end

    def include?(e)
      false
    end

    def to_ary
      []
    end
  end

  class EventsOfClass < BEvent

    def initialize(klass)
      @klass = klass
    end

    def ==(other)
      other.is_a? @klass
    end

    def include?(e)
      e.is_a? @klass
    end

    def inspect
      @klass.inspect
    end

  end

  class CopyContEvent

    def initialize(return_cont)
      @return = return_cont
    end

    def call(arg)
      @return.call arg
    end
  end

  def event_set(name, *events)
    EventSetClass.new name, events
  end

  def any
    Any.instance
  end

  def none
    None.instance
  end

  def event_of_class(klass)
    EventsOfClass.new klass
  end

  def copy_cont_event(return_cont)
    CopyContEvent.new return_cont
  end

  module_function :event_set, :any, :none,
                  :event_of_class, :copy_cont_event

end
