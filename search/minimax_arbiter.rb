require_relative 'search_arbiter'

class MinimaxArbiter < AdversarialSearchArbiter

  def search(node)
    action = nil
    val = -Float::INFINITY
    legals = node.program.legal_events
    # puts "legal events are #{legals.inspect}"
    legals.each do |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      child = node.apply ev
      ev_val = min(child)
      if val < ev_val
        action = ev
        val = ev_val
      end
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
      node.restore
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
      child = node.apply ev
      maxval = max(child)
      val = [val, maxval].min
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
      node.restore
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
      child = node.apply ev
      minval = min(child)
      val = [val, minval].max
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
      node.restore
    }
    val
  end

end