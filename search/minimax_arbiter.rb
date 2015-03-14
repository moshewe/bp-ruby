require_relative 'search_arbiter'

class MinimaxArbiter < AdversarialSearchArbiter

  def search(node)
    action = nil
    val = -Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each do |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      ev_val = min(node.apply ev)
      if val < ev_val
        action = ev
        val = ev_val
      end
      finished_exploring node, ev
    end
    action
  end

  def min(node)
    return h node if terminal? node
    val = Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      val = [val,
             max(node.apply ev)].min
      finished_exploring node, ev
    }
    val
  end

  def max(node)
    return h node if terminal? node
    val = -Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      val = [val,
             min(node.apply ev)].max
      finished_exploring node, ev
    }
    val
  end

  def finished_exploring(node, ev)
    puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
    puts "restoring state... last action: " + node.actions.inspect
    node.restore_state
  end

end