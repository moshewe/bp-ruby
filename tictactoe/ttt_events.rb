module TTTEvents
  include(EventSet)

  class Move < BEvent
    attr_accessor :x, :y

    def initialize(x,y)
      @x = x
      @y = y
    end

    def inspect
      @name
    end
  end

  class X < Move
    def initialize(x,y)
      super x, y
      @name = "X(#{x},#{y})"
    end
  end

  class O < Move
    def initialize(x,y)
      super x, y
      @name = "O(#{x},#{y})"
    end
  end

  class XEvents < BEvent
    def include?(e)
      e.is_a? X
    end

    def inspect
      "XEvents"
    end

    @@instance = XEvents.new

    def self.instance
      return @@instance
    end

  end

  class OEvents < BEvent
    def include?(e)
      e.is_a? O
    end

    def inspect
      "OEvents"
    end

    @@instance = OEvents.new

    def self.instance
      return @@instance
    end
  end

  def TTTEvents.xevents
    return XEvents.instance
  end

  def TTTEvents.oevents
    return OEvents.instance
  end

  @draw = BEvent.new "Draw"
  @owin = BEvent.new "OWin"
  @xwin = BEvent.new "Xwin"
  @game_over = BEvent.new "Game Over"

  attr_accessor :draw, :owin, :xwin, :game_over

end