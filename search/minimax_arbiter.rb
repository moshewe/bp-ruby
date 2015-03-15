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
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
      node.restore_state
    end
    action
  end

  def min(node)
    return h.call(node) if terminal? node
    val = Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      maxval = max(node.apply ev)
      val = [val, maxval].min
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
      node.restore_state
    }
    val
  end

  def max(node)
    return h.call(node) if terminal? node
    val = -Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      minval = min(node.apply ev)
      val = [val, minval].max
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
      node.restore_state
    }
    val
  end

end