require_relative '../../bp'

class EnforceTurns < BThread
  include(TTTEvents)

  attr_reader :current

  def initialize
    @name = 'EnforceTurns'
    @current = :X
    @bodyfunc = lambda { |ev|
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
    }
  end


  def make_move(row, col)
    if @current == :X
      X.new row, col
    else
      O.new row, col
    end
  end

end