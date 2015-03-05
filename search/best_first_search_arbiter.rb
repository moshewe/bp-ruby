require_relative '../bp'

class BestFirstSearchArbiter < Arbiter

  attr_accessor :h
  attr_accessor :terminal_func, :sim_bthreads

  def initialize(h, terminal_func = nil)
    @sim_bthreads = nil
    if h.is_a? Hash
      @h = lambda { |ev| h[ev] }
      terminal_events = h.select
      lambda { |ev, val|
        val == Float::INFINITY ||
            -Float::INFINITY
      }.keys
      @terminal_func = lambda { |bps|
        terminal_events.include? bps.program.le
      }
    else
      @h = h
      @terminal_func = terminal_func
    end
  end

  def terminal?(node)
    terminal_func.call node
  end

  def search(root)
    openlist = [root]
    while (!openlist.empty?)
      best = openlist.pop
      if terminal? best then
        return best.actions.first
      end
      openlist.concat best.expand
      openlist.sort_by { |n| h(n) }
    end
    nil
  end

  def select_event(legal=[])
    root = SearchNode.new(program)
    sandbox_on
    sol = search(root)
    sandbox_off
    sol.actionlist.first
  end

  def sandbox_on
    p "entering sandbox mode"
    @sim_bthreads.each { |sbt| sbt.sandbox_on }
    @backup_in_pipe = @in_pipe
    @backup_out_pipe = @out_pipe
    @in_pipe = []
    @out_pipe = []
  end

  def sandbox_off
    @sim_bthreads.each { |sbt| sbt.sandbox_off }
    @in_pipe = @backup_in_pipe
    @out_pipe = @backup_out_pipe
    p "exited sandbox mode"
  end

end