require_relative '../../bp'

class EnforceTurns < BThread
  include(TTTEvents)

  attr_reader :current

  def initialize
    BThread.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    @name = 'EnforceTurns'
    @current = :X
  end

  def body(le)
    while (true)
      @current = :X
      bsync({:request => none,
             :wait => xevents,
             :block => oevents})
      @current = :O
      bsync({:request => none,
             :wait => oevents,
             :block => xevents})
    end
  end

  def make_move(row, col)
    if @current == :X
      X.new row, col
    else
      O.new row, col
    end
  end

end