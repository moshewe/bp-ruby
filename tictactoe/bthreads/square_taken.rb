require_relative '../../bp'

class SquareTaken < BThread
  include TTTEvents

  @board
  attr_accessor :row, :col, :board

  def initialize(row, col)
    BThread.instance_method(:initialize).bind(self).call
    # TTTEvents.instance_method(:initialize).bind(self).call
    @row = row
    @col = col
    @name = "SquareTaken(#{row},#{col})"
  end

  def body(le)
    move = Move.new row, col
    self.bsync({:request => none,
                :wait => move, :block => none})
    self.board[[row, col]].set_enabled false
    self.bsync({:request => none,
                :wait => none, :block => move})
  end

  def self.gen_all_st
    bts = []
    for i in 1..3 do
      for j in 1..3 do
        bts.push SquareTaken.new i, j
      end
    end
    bts
  end
end

# puts EventSet.none.inspect