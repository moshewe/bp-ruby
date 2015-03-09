require_relative '../bp'
require_relative '../arbiter_event_selectors/default_event_selector'

class SearchArbiter < Arbiter

  attr_accessor :h, :sandbox, :terminal_func, :sim_bthreads

  class SearchArbiterEventSelector < DefaultEventSelector
    def select_event(legal)
      if arbiter.sandbox
        puts "IN SANDBOX - NO EVENT SELECTION"
      else
        @arbiter.sandbox_on
        @arbiter.search(BPState.new @arbiter.program)
        @arbiter.sandbox_off
      end
    end
  end

  def initialize(h, terminal_func = nil)
    @sim_bthreads = nil
    @selector = SearchArbiterEventSelector.new self
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

  alias_method :super_ask_for_external, :ask_for_external

  def ask_for_external
    if @sandbox
      puts "IN SANDBOX - dropping request for external event..."
    else
      ask_for_external_no_sandbox
    end
  end

  def ask_for_external_no_sandbox
    super_ask_for_external
  end

  def sandbox_on
    p "=== ENTERING SANDBOX MODE ==="
    @sandbox = true
    @sim_bthreads.each { |sbt| sbt.sandbox_on }
    @backup_in_pipe = @in_pipe
    @backup_out_pipe = @out_pipe
    @in_pipe = []
    @out_pipe = []
  end

  def sandbox_off
    @sandbox = false
    @sim_bthreads.each { |sbt| sbt.sandbox_off }
    @in_pipe = @backup_in_pipe
    @out_pipe = @backup_out_pipe
    p "=== EXITED SANDBOX MODE ==="
  end

  def search(node)
    puts "PLEASE IMPLEMENT SEARCH METHOD"
  end

end