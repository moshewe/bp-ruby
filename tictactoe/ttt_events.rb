require_relative '../event_set'

module TTTEvents
  include EventSet

  attr_reader :draw, :owin, :xwin, :game_over
  module_function :draw, :owin, :xwin, :game_over

  @draw = BEvent.new "Draw"
  @owin = BEvent.new "OWin"
  @xwin = BEvent.new "XWin"
  @game_over = BEvent.new "Game Over"

  # def initialize
  #   super
  # end

  class Move < BEvent
    attr_accessor :x, :y

    def initialize(x, y)
      super "Move(#{x},#{y})"
      @x = x
      @y = y
    end

    def ==(other)
      (other.is_a? Move) &&
          move.x == other.x &&
          move.y == other .y
    end
  end

  class X < Move
    def initialize(x, y)
      super x, y
      @name = "X(#{x},#{y})"
    end

    def ==(other)
      (other.is_a? X) &&
          move.x == other.x &&
          move.y == other .y
    end
  end

  class O < Move
    def initialize(x, y)
      super x, y
      @name = "O(#{x},#{y})"
    end

    def ==(other)
      (other.is_a? O) &&
          move.x == other.x &&
          move.y == other .y
    end
  end

  class XEvents < EventsOfClass
    include Singleton

    def initialize
      super X
    end

  end

  class OEvents < EventsOfClass
    include Singleton

    def initialize
      super O
    end

  end

  def xevents
    return XEvents.instance
  end

  def oevents
    return OEvents.instance
  end

end