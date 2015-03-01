require_relative '../../bp'

class SquareTaken < BThread

  @board
  attr_accessor :row, :col, :board

  def initialize(row, col)
    super()
    @row = row
    @col = col
    @name = "SquareTaken(#{row},#{col})"
    @bodyfunc = lambda { |ev|
      Move move = Move.new(row, col)
      self.bsync({:request => EventSet.none,
                  :wait => move, :block => EventSet.none })
      self.board[[row,col]].set_enabled false
      self.bsync({ :request => EventSet.none,
                   :wait => EventSet.none, :block => move })
    }
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