require_relative '../base_events'

# AKA BPState
class BPState

  attr_accessor :bt_states, :program, :actions

  class BTState
    include BaseEvents

    def initialize(bt)
      @bt = bt
      @request = bt.request
      @wait = bt.wait
      @block = bt.block
      @cont = callcc do |cc|
        cce = copy_cont_event cc
        bt.resume cce
      end
      @name = bt.name
      @program = bt.program
      @bodyfunc = bt.bodyfunc
      @alive = bt.alive
    end

    def restore
      @bt.request = @request
      @bt.wait = @wait
      @bt.block = @block
      @bt.cont = @cont
      @bt.name = @name
      @bt.program = @program
      @bt.bodyfunc = @bodyfunc
      @bt.alive = @alive
    end

  end

  def initialize(program)
    @program = program
    @actions = []
    save_prog_state
    @bt_states = program.bthreads.map do |bt|
      BTState.new bt
    end
    # puts "BPState created!"
  end

  def save_prog_state
    @arbiter = program.arbiter
    @bthreads = Array.new program.bthreads
    @le = program.le
    @in_pipe = program.in_pipe
    @out_pipe = program.out_pipe
    @emitq = program.emitq
    @cont = program.cont
    @return_cont = program.return_cont
  end

  def restore_prog_state
    program.arbiter = @arbiter
    program.bthreads = @bthreads
    program.le = @le
    program.in_pipe = @in_pipe
    program.out_pipe = @out_pipe
    program.emitq = @emitq
    program.cont = @cont
    program.return_cont = @return_cont
  end

  def apply(action)
    program.fire(action)
    result = BPState.new program
    result.actions = Array.new actions
    result.actions.push action
    result
  end

  def restore
    restore_prog_state
    @bt_states.each do |bts|
      bts.restore
    end
  end

  def inspect
    "BPState" + actions.inspect
  end

end