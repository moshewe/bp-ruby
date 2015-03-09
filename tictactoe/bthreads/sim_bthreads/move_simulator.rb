require_relative '../../../b_thread'

class MoveSimulator < BThread
  include TTTEvents

  attr_reader :enforcer, :row, :col

  def initialize(enforcer, row, col)
    super()
    @name = "MoveSimulator(#{row},#{col})"
    @enforcer = enforcer
    @row = row
    @col = col
    @moved = false
  end

  def body(le)
    while true
      e = bsync
      if e == @req_move
        puts @name + "'s move triggered! Won't request ever again!"
        @moved = true
      end
    end
  end

  def sandbox_on
    puts @name + "turned sandbox ON! "
    if !@moved
      @req_move = enforcer.make_move(row, col)
      @request = @req_move
      puts @name + " changed request to " + @request.inspect
    end
  end

  def sandbox_off
    puts "turned sandbox OFF! " + @name
    @request = none
    puts @name + " changed request to " + @request.inspect
  end
end

def MoveSimulator.gen_all_move_sim(enforcer)
  (0..2).map { |row|
    (0..2).map { |col|
      MoveSimulator.new enforcer, row, col
    } }.flatten
end