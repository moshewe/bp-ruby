# AKA BPState
class BPState

  attr_accessor :bt_states, :program, :actions

  def initialize(program)
    @program = program
    @actions = []
    save_state(program)
  end

  def save_state(program)
    puts "saving state"
    @bp_state = {}
    program.instance_variables.each do |var|
      @bp_state[var] = instance_variable_get(var)
    end
    @bt_states = {}
    program.bthreads.each { |bth|
      bts = {}
      bth.instance_variables.each do |var|
        bts[var] = instance_variable_get(var)
      end
      @bt_states[bth] = bts
    }
  end

  def expand
    program.legal_events.map {|ev|
      apply ev
    }
  end

  def apply(action)
    program.fire(action)
    result = BPState.new program
    result.actions.push action
    restore_state
    result
  end

  def restore_state
    puts "restoring state... last action: " + actions.last.inspect
    @bp_state.each do |var,val|
      program.instance_variable_set var, val
    end
    bt_states.each do |bth, bts|
      bts.each do |varname, varval|
        bth.instance_variable_set varname, varval
      end
    end
  end

end