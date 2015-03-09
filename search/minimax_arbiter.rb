require_relative 'search_arbiter'

class MinimaxArbiter < AdversarialSearchArbiter

  def search(node)
    action = nil
    val = -Float::INFINITY
    legals = node.program.legal_events
    puts "legal events are #{legals.inspect}"
    legals.each do |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      ev_val = min(node.apply ev)
      if val < ev_val
        action = ev
        val = ev_val
      end
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
    end
    action
  end

  def min(node)
    return h node if terminal? node
    val = Float::INFINITY
    legals = node.program.legal_events
    puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      val = [val,
             max(node.apply ev)].min
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
    }
    val
  end

  def max(node)
    return h node if terminal? node
    val = -Float::INFINITY
    legals = node.program.legal_events
    puts "legal events are #{legals.inspect}"
    legals.each { |ev|
      puts "MINIMAX EXPLORING #{ev.inspect}"
      val = [val,
             min(node.apply ev)].max
      puts "MINIMAX FINISHED EXPLORING #{ev.inspect}"
    }
    val
  end

end