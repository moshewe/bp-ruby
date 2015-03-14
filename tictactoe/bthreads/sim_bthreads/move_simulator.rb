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
    @sandbox = false
  end

  def body(le)
    while true
      bsync(make_bsync_hash)
      # if e.is_a?(Move) && e.x == @row && e.y == @col
      #   puts @name + "'s move triggered! Won't request ever again!"
      #   @moved = true
      # end
    end
  end

  def make_bsync_hash
    if @sandbox
      move = enforcer.make_move(row, col)
      # puts @name + " is requesting " + move.inspect
      {:request => move, :wait => EventsOfClass.new(Move)}
    else
      {}
    end
  end

  def sandbox_on
    puts @name + "turned sandbox ON! "
    # if !@moved
    # @req_move = enforcer.make_move(row, col)
    @request = enforcer.make_move(row, col)
    @wait = EventsOfClass.new Move
    puts @name + " changed request to " + @request.inspect
    # end
    @sandbox = true
  end

  def sandbox_off
    puts "turned sandbox OFF! " + @name
    @request = none
    puts @name + " changed request to " + @request.inspect
    @sandbox = false
  end
end

def MoveSimulator.gen_all_move_sim(enforcer)
  (0..2).map { |row|
    (0..2).map { |col|
      MoveSimulator.new enforcer, row, col
    } }.flatten
end