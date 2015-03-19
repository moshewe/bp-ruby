require_relative '../bp'
require_relative '../arbiter_event_selectors/default_event_selector'

class SearchArbiter < Arbiter

  attr_accessor :h, :sandbox, :terminal_func, :sim_bthreads,
                :selector

  class StartSearchSelector < DefaultEventSelector

    def initialize(arbiter)
      super
      @wiss = WhileInSearchSelector.new @arbiter
    end

    def select_event(legal)
      @arbiter.sandbox_on
      @arbiter.program.arbiter.selector = @wiss
      ans = @arbiter.search(BPState.new @arbiter.program)
      @arbiter.program.arbiter.selector = self
      @arbiter.sandbox_off
      ans
    end
  end

  class WhileInSearchSelector < DefaultEventSelector
    def select_event(legal)
      puts "IN SEARCH, NOT SELECTING EVENTS"
      nil
    end
  end

  def initialize(h, terminal_func = nil)
    @sim_bthreads = nil
    @selector = StartSearchSelector.new self
    @sandbox = false
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
      @sandbox = false
    end
  end

  def terminal?(node)
    terminal_func.call node
  end

  def sandbox_on
    puts "=== ENTERING SANDBOX MODE ==="
    @sandbox = true
    @sim_bthreads.each { |sbt| sbt.sandbox_on }
    puts "=== ALL SIM-BTHREADS IN SANDBOX MODE ==="
    # @backup_in_pipe = @in_pipe
    # @backup_out_pipe = @out_pipe
    # @in_pipe = []
    # @out_pipe = []
  end

  def sandbox_off
    @sandbox = false
    @sim_bthreads.each { |sbt| sbt.sandbox_off }
    # @in_pipe = @backup_in_pipe
    # @out_pipe = @backup_out_pipe
    puts "=== EXITED SANDBOX MODE ==="
  end

  def search(node)
    puts "PLEASE IMPLEMENT SEARCH METHOD"
  end

  def next_event
    return super if !@sandbox
    # puts "END BP loop - IN SEARCH, NOT SELECTING EVENT"
    program.back_to_caller
  end
end