require_relative 'search_arbiter'

class AdversarialSearchArbiter < SearchArbiter

  attr_accessor :enforcer
  attr_reader :agent_player

  def initialize(enforcer = nil, agent_player = :O,h = nil, terminal = nil)
    @enforcer = enforcer
    @agent_player = agent_player
    puts "AGENT'S PLAYER IS " + agent_player.id2name
    super h, terminal
  end

  def ask_for_external_no_sandbox
    puts "Current Player: " + @enforcer.current.id2name
    if @enforcer.current == agent_player
      puts "AGENT'S TURN - WILL SEARCH FOR EVENT"
    else
      puts "NOT AGENT'S TURN - ASKING FOR EXTERNAL (NO SANDBOX)"
      super.ask_for_external_no_sandbox
    end
  end

end