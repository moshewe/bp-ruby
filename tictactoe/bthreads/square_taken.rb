require_relative '../../bp'

class SquareTaken < BThread
  include TTTEvents

  attr_accessor :row, :col#, :board

  def initialize(row, col)
    BThread.instance_method(:initialize).bind(self).call
    @row = row
    @col = col
    @name = "SquareTaken(#{row},#{col})"
  end

  def body(le)
    move = Move.new row, col
    self.bsync({:wait => move})
    # self.board[[row, col]].set_enabled false
    self.bsync({:request => none,
                :wait => none, :block => move})
  end

end

def SquareTaken.gen_all_st
  (0..2).map { |row|
    (0..2).map { |col|
      SquareTaken.new row, col
    } }.flatten
end
# puts EventSet.none.inspect