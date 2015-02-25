# AKA BPState
class SearchNode

  attr_accessor :bt_states
  attr_accessor :program
  attr_accessor :actions

  def initialize(program)
    @program = program
    @actions = []
    @bt_states = {}
    program.bthreads.each { |bth|
      bts = {}
      bth.instance_variables.each do |var|
        bts[var] = instance_variable_get(var)
      end
      bt_states[bth] = bts
    }
  end

  def expand
    program.legal_events.map {|ev|
      program.fire(ev)
      child = SearchNode.new program
      child.action = actions + ev
      restore
      child
    }
  end

  def restore
    bt_states.each do |bth, bts|
      bts.each do |varname, varval|
        bth.instance_variable_set varname, varval
      end
    end
  end

end