# AKA BPState
class BPState

  attr_accessor :bt_states, :program, :actions

  def initialize(program)
    @program = program
    @actions = []
    save_state(program)
    puts "BPState created!"
  end

  def save_state(program)
    save_prog_state(program)
    @bt_states = {}
    program.bthreads.each { |bth|
      @bt_states[bth] = save_bt_state(bth)
    }
  end

  def save_bt_state(bth)
    bts = {}
    bth.instance_variables.each do |var|
      val = bth.instance_variable_get(var)
      bts[var] = val.clone if defined? val.clone
    end
    bts
  end

  def save_prog_state(program)
    @bp_state = {}
    program.instance_variables.each do |var|
      val = program.instance_variable_get(var)
      @bp_state[var] = val if defined? val.clone
    end
  end

  def expand
    program.legal_events.map {|ev|
      apply ev
    }
  end

  def apply(action)
    program.fire(action)
    result = BPState.new program
    result.actions = Array.new actions
    result.actions.push action
    result
  end

  def restore_state
    @bp_state.each do |var,val|
      program.instance_variable_set var, val
    end
    bt_states.each do |bth, bts|
      bts.each do |varname, varval|
        bth.instance_variable_set varname, varval
      end
    end
    puts "restored state to " + inspect
  end

  def inspect
    actions.inspect
  end

end