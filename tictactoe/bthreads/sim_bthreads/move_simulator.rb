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
  end

  def body(le)
    while true
      bsync
    end
  end

  def sandbox_on
    @request = enforcer.make_move(row, col)
    puts "turned sandbox ON! " + @name +
             " changed requst to " + @request
  end

  def sandbox_off
    @request = none
    puts "turned sandbox OFF! " + @name +
             " changed requst to " + @request
  end
end

def MoveSimulator.gen_all_move_sim(enforcer)
  (0..2).map { |row|
    (0..2).map { |col|
      MoveSimulator.new enforcer, row, col
    } }.flatten
end